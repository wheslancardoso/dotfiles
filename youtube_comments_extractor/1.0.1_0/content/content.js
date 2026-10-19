// Content script for YouTube Comments Extractor (Modern Streaming Engine)
// Extracts comments and replies progressively, sends batches in real-time, supports pause/resume

(function () {
  "use strict";

  let isRunning = false;
  let shouldStop = false;
  let knownCommentIds = new Set();
  let expandedThreadIds = new Set();

  const SELECTORS = {
    commentsSection: "ytd-comments#comments",
    commentThread: "ytd-comment-thread-renderer",
    commentRenderer: "ytd-comment-view-model",
    commentContent: "yt-attributed-string#content-text",
    commentContentText: "yt-attributed-string#content-text span.yt-core-attributed-string",
    authorName: "a#author-text",
    authorChannel: "a#author-text",
    publishedTime: "#published-time-text a",
    likeCount: "#vote-count-middle",
    replyButton: "#more-replies button, ytd-button-renderer#more-replies button",
    repliesRenderer: "#replies",
    showMoreReplies: "#continuation button, ytd-continuation-item-renderer button",
    commentExpander: "#expander #more",
    videoTitle: "h1.ytd-watch-metadata yt-formatted-string, h1 yt-formatted-string",
    channelName: "ytd-channel-name #text a, #channel-name yt-formatted-string a",
    viewCount: "#info-container #view-count, ytd-watch-info-text #view-count",
    uploadDate: "#info-strings yt-formatted-string:last-child",
    commentCount: "#count yt-formatted-string span:first-child",
    pinnedBadge: "#pinned-comment-badge",
    heartBadge: "#creator-heart",
    memberBadge: "#sponsor-comment-badge",
    authorBadgeOwner: "#author-comment-badge",
    editedBadge: "#published-time-text .edited",
    replyCount: "#more-replies span, #replies #expander-contents #more-text",
    continuationLoader: "ytd-comments#comments ytd-continuation-item-renderer, #comments #contents > ytd-continuation-item-renderer, ytd-item-section-renderer ytd-continuation-item-renderer",
  };

  function delay(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  function hashString(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = (hash << 5) - hash + char;
      hash |= 0;
    }
    return Math.abs(hash).toString(36);
  }

  function getVideoInfo() {
    const title =
      document.querySelector(SELECTORS.videoTitle)?.textContent?.trim() ||
      document.title.replace(" - YouTube", "").trim() ||
      "Vídeo do YouTube";
    const channel =
      document.querySelector(SELECTORS.channelName)?.textContent?.trim() ||
      "Canal Desconhecido";
    const viewCount =
      document.querySelector(SELECTORS.viewCount)?.textContent?.trim() || "";
    const commentCountEl = document.querySelector(SELECTORS.commentCount);
    const totalComments = commentCountEl?.textContent?.trim() || "";

    const urlParams = new URLSearchParams(window.location.search);
    const videoId = urlParams.get("v") || "desconhecido";

    return {
      title,
      channel,
      videoId,
      url: window.location.href,
      viewCount,
      totalComments,
      lastUpdated: new Date().toISOString(),
    };
  }

  function parseLikeCount(str) {
    if (!str || str === "" || str === "0") return 0;
    str = str.replace(/,/g, "").trim();
    if (str.endsWith("K") || str.endsWith("k")) {
      return Math.round(parseFloat(str) * 1000);
    } else if (str.endsWith("M") || str.endsWith("m")) {
      return Math.round(parseFloat(str) * 1000000);
    }
    const num = parseInt(str, 10);
    return isNaN(num) ? 0 : num;
  }

  function parseReportedCommentCount() {
    const selectors = [
      "ytd-comments-header-renderer #count yt-formatted-string span:first-child",
      "ytd-comments-header-renderer #count .count-text",
      "#comments #count yt-formatted-string",
      "#comments #title yt-formatted-string",
      "#count.ytd-comments-header-renderer",
    ];
    for (const sel of selectors) {
      const el = document.querySelector(sel);
      if (el && el.textContent) {
        const clean = el.textContent.replace(/\./g, "").replace(/,/g, "").trim();
        const match = clean.match(/\d+/);
        if (match) return parseInt(match[0], 10);
      }
    }
    return 0;
  }

  function parseComment(commentEl, isReply = false) {
    if (!commentEl) return null;

    try {
      const authorEl = commentEl.querySelector(SELECTORS.authorName);
      const authorChannelEl = commentEl.querySelector(SELECTORS.authorChannel);
      const author = authorEl?.textContent?.trim() || "Anônimo";
      const authorChannelUrl = authorChannelEl?.href || "";
      const authorChannelId = authorChannelUrl.split("/").pop() || "";

      const contentEl = commentEl.querySelector(SELECTORS.commentContent);
      const contentTextEl = commentEl.querySelector(SELECTORS.commentContentText);
      const commentText = (
        contentTextEl?.textContent ||
        contentEl?.textContent ||
        ""
      ).trim();
      const commentHtml = contentEl?.innerHTML || "";

      const timeEl = commentEl.querySelector(SELECTORS.publishedTime);
      const publishedTime = timeEl?.textContent?.trim() || "";
      const isEdited =
        publishedTime.toLowerCase().includes("edit") ||
        publishedTime.toLowerCase().includes("modifi") ||
        commentEl.querySelector(SELECTORS.editedBadge) !== null;

      const likeEl = commentEl.querySelector(SELECTORS.likeCount);
      const likeCount = parseLikeCount(likeEl?.textContent?.trim() || "0");

      const pinnedBadgeEl = commentEl.querySelector(SELECTORS.pinnedBadge);
      const isPinned = isReply ? false : pinnedBadgeEl !== null && pinnedBadgeEl.children.length > 0;

      const creatorHeartEl = commentEl.querySelector(SELECTORS.heartBadge);
      const hasCreatorHeart = creatorHeartEl !== null && creatorHeartEl.children.length > 0;
      const isMember = commentEl.querySelector(SELECTORS.memberBadge) !== null;
      const isOwner = commentEl.querySelector(SELECTORS.authorBadgeOwner) !== null;

      // Extract canonical YouTube Comment ID from permalink URL (?lc=...)
      let commentId = null;
      if (timeEl && timeEl.href) {
        try {
          const url = new URL(timeEl.href, window.location.origin);
          commentId = url.searchParams.get("lc");
        } catch (e) {}
      }

      if (!commentId) {
        const domId = commentEl.getAttribute("id") || commentEl.closest("[id]")?.getAttribute("id");
        if (domId && domId !== "comment" && !domId.startsWith("comment_")) {
          commentId = domId;
        }
      }

      // Deterministic fallback (zero random duplicates)
      if (!commentId) {
        commentId = "c_" + hashString(`${author}_${publishedTime}_${commentText.substring(0, 100)}`);
      }

      return {
        id: commentId,
        rawId: commentId,
        author: {
          name: author,
          channelUrl: authorChannelUrl,
          channelId: authorChannelId,
          isOwner,
          isMember,
        },
        content: {
          text: commentText,
          html: commentHtml,
        },
        publishedTime,
        isEdited,
        likeCount,
        isPinned,
        hasCreatorHeart,
        isReply,
      };
    } catch (err) {
      console.warn("[YT Extractor] Error parsing comment:", err);
      return null;
    }
  }

  function getMainContinuationLoader() {
    const comments = document.querySelector(SELECTORS.commentsSection);
    if (!comments) return null;
    const all = comments.querySelectorAll("ytd-continuation-item-renderer");
    for (const c of all) {
      if (!c.closest("ytd-comment-thread-renderer") && !c.closest("#replies") && !c.closest("ytd-comment-replies-renderer")) {
        return c;
      }
    }
    return null;
  }

  function getThreadReplyButtons(thread) {
    const allBtns = thread.querySelectorAll("button");
    const valid = [];
    for (const b of allBtns) {
      const txt = (b.innerText || b.getAttribute("aria-label") || "").toLowerCase().trim();
      const isSingleReplyAction = txt === "reply" || txt === "responder";
      const isReply = (txt.includes("resposta") || txt.includes("repl")) && !txt.includes("ocultar") && !txt.includes("hide") && !isSingleReplyAction;
      if (isReply && b.offsetParent !== null && b.getBoundingClientRect().height > 0) {
        valid.push(b);
      }
    }
    return valid;
  }

  function getThreadReplyPaginator(thread) {
    const replies = thread.querySelector(SELECTORS.repliesRenderer);
    if (!replies) return null;
    const btns = replies.querySelectorAll("ytd-continuation-item-renderer button, #continuation button");
    for (const b of btns) {
      const txt = (b.innerText || b.getAttribute("aria-label") || "").toLowerCase().trim();
      const isSingleReplyAction = txt === "reply" || txt === "responder";
      const isMoreReplies = (txt.includes("resposta") || txt.includes("repl") || txt.includes("mais") || txt.includes("more")) && !txt.includes("ocultar") && !txt.includes("hide") && !isSingleReplyAction;
      if (isMoreReplies && b.offsetParent !== null && b.getBoundingClientRect().height > 0) {
        return b;
      }
    }
    return null;
  }

  async function scrollToComments() {
    let section = document.querySelector(SELECTORS.commentsSection);
    const scrollTargets = [600, 1000, 1500, 2000];
    let idx = 0;

    while (!section && idx < scrollTargets.length) {
      window.scrollTo({ top: scrollTargets[idx], behavior: "instant" });
      await delay(700);
      section = document.querySelector(SELECTORS.commentsSection);
      idx++;
    }

    if (section) {
      section.scrollIntoView({ behavior: "instant", block: "start" });
      await delay(1000);
      return true;
    }
    return false;
  }

  function pauseVideoPlayer() {
    const video = document.querySelector("video.html5-main-video, video");
    if (video && !video.paused) {
      video.pause();
      console.log("[YT Extractor] Vídeo pausado automaticamente para economizar CPU/GPU.");
    }
  }

  function checkCommentsDisabled() {
    const disabledMsg = document.querySelector("ytd-comments#comments #message, ytd-message-renderer #message");
    if (disabledMsg) {
      const text = disabledMsg.textContent?.toLowerCase() || "";
      if (text.includes("desativad") || text.includes("disabled") || text.includes("turned off")) {
        return true;
      }
    }
    return false;
  }

  async function applySortOrder(desiredOrder = "newest") {
    if (desiredOrder !== "newest") return;
    try {
      const sortBtn = document.querySelector(
        "#sort-menu button, yt-sort-filter-sub-menu-renderer yt-dropdown-menu, #sort-menu tp-yt-paper-button, #sort-menu yt-button-shape button"
      );
      if (!sortBtn) return;
      sortBtn.click();
      await delay(450);

      const menuItems = document.querySelectorAll(
        "tp-yt-paper-listbox ytd-menu-service-item-renderer, tp-yt-paper-listbox a, tp-yt-paper-item, ytd-menu-service-item-renderer"
      );
      for (const item of menuItems) {
        const txt = item.textContent?.toLowerCase() || "";
        if (txt.includes("recent") || txt.includes("newest")) {
          item.click();
          console.log("[YT Extractor] Ordenação alternada para 'Mais recentes primeiro'.");
          await delay(2000); // Aguarda o YouTube reconstruir a lista no DOM
          break;
        }
      }
    } catch (e) {
      console.warn("[YT Extractor] Não foi possível alternar ordenação:", e);
    }
  }

  // Listen for SPA navigation within YouTube
  window.addEventListener("yt-navigate-finish", () => {
    console.log("[YT Extractor] Navegação interna detectada no YouTube.");
    knownCommentIds.clear();
    expandedThreadIds.clear();
    shouldStop = true;
    chrome.runtime.sendMessage({
      action: "videoNavigated",
      videoInfo: getVideoInfo(),
    }).catch(() => {});
  });

  // Main Streaming Extraction Loop (Arquitetura 2 Fases Soberana)
  async function runStreamingExtraction(options) {
    const { videoId, throttle = 600, maxComments = 0, autoPause = true, sortOrder = "newest" } = options;
    isRunning = true;
    shouldStop = false;

    console.log("[YT Extractor] Iniciando extração exaustiva de 2 fases para vídeo:", videoId);

    // Auto-pause video to save CPU/GPU/RAM
    if (autoPause) {
      pauseVideoPlayer();
    }

    const videoInfo = getVideoInfo();

    // Broadcast initial start status
    chrome.runtime.sendMessage({
      action: "commentsBatch",
      videoId,
      videoInfo,
      comments: [],
      progress: { percentage: 5, message: "Localizando seção de comentários..." },
      isFinished: false,
    });

    // Check if comments are disabled
    if (checkCommentsDisabled()) {
      chrome.runtime.sendMessage({
        action: "commentsDisabled",
        videoId,
      });
      isRunning = false;
      return;
    }

    const loaded = await scrollToComments();
    if (!loaded) {
      if (checkCommentsDisabled()) {
        chrome.runtime.sendMessage({
          action: "commentsDisabled",
          videoId,
        });
        isRunning = false;
        return;
      }
      console.warn("[YT Extractor] Seção de comentários demorou a responder, prosseguindo com busca profunda.");
    }

    // Apply Sort Order (Mais recentes primeiro)
    if (sortOrder === "newest") {
      await applySortOrder("newest");
    }

    let totalExtractedRoots = 0;
    let totalRepliesFound = 0;
    let pendingBatch = [];
    const allExtractedRootsMap = new Map();

    function sendProgress(percentage, message, commentCount = 0, replyCount = 0) {
      chrome.runtime.sendMessage({
        action: "progressUpdate",
        progress: {
          percentage,
          message,
          commentCount,
          replyCount,
        },
      }).catch(() => {});
    }

    async function flushBatch(percentage, message) {
      if (pendingBatch.length > 0) {
        chrome.runtime.sendMessage({
          action: "commentsBatch",
          videoId,
          videoInfo: getVideoInfo(),
          comments: pendingBatch,
          progress: { percentage, message },
          isFinished: false,
        }).catch(() => {});
        pendingBatch = [];
      }
    }

    // =========================================================================
    // FASE 1: ROLAGEM EXAUSTIVA & STREAMING DOS COMENTÁRIOS PRINCIPAIS (ROOTS)
    // =========================================================================
    let previousThreadsCount = 0;
    let stallCount = 0;
    const maxStallAttempts = 22; // Tolerância estendida contra latência e throttling de rede
    const expectedTotal = parseReportedCommentCount();

    console.log(`[YT Extractor] FASE 1 iniciada. Total informado pelo YouTube: ${expectedTotal || "desconhecido"}`);

    while (!shouldStop) {
      const threadElements = document.querySelectorAll(SELECTORS.commentThread);
      const currentThreadsCount = threadElements.length;

      // Extrai novos comentários principais encontrados no DOM
      for (let i = 0; i < threadElements.length && !shouldStop; i++) {
        const thread = threadElements[i];
        const mainCommentEl = thread.querySelector("#comment");
        if (!mainCommentEl) continue;

        const mainComment = parseComment(mainCommentEl, false);
        if (!mainComment) continue;

        const rootId = mainComment.rawId || mainComment.id;
        if (!knownCommentIds.has(rootId)) {
          knownCommentIds.add(rootId);
          mainComment.replies = [];
          allExtractedRootsMap.set(rootId, mainComment);
          pendingBatch.push(mainComment);
          totalExtractedRoots++;
        }

        // Streaming contínuo a cada 20 itens para o IndexedDB
        if (pendingBatch.length >= 20) {
          const pct = maxComments > 0
            ? Math.min(60, (totalExtractedRoots / maxComments) * 60)
            : expectedTotal > 0
            ? Math.min(60, (totalExtractedRoots / expectedTotal) * 60)
            : 30;
          await flushBatch(
            pct,
            `Carregando comentários principais... (${totalExtractedRoots}${expectedTotal > 0 ? ` / ~${expectedTotal}` : ""} salvos)`
          );
          sendProgress(
            pct,
            `Carregando comentários principais... (${totalExtractedRoots}${expectedTotal > 0 ? ` / ~${expectedTotal}` : ""})`,
            totalExtractedRoots,
            0
          );
        }

        if (maxComments > 0 && totalExtractedRoots >= maxComments) {
          break;
        }
      }

      if (maxComments > 0 && totalExtractedRoots >= maxComments) {
        console.log("[YT Extractor] Limite máximo de comentários atingido na Fase 1.");
        break;
      }

      // Localiza o carregador de continuação do YouTube no DOM (apenas dos comentários principais)
      const continuationLoader = getMainContinuationLoader();

      if (currentThreadsCount === previousThreadsCount) {
        stallCount++;

        if (continuationLoader) {
          // O elemento de continuação ainda está no DOM: O YouTube tem mais comentários!
          // Desperta o IntersectionObserver com scroll instantâneo
          window.scrollBy({ top: -350, behavior: "instant" });
          await delay(150);
          continuationLoader.scrollIntoView({ behavior: "instant", block: "center" });
          window.dispatchEvent(new Event("scroll"));

          const pct = maxComments > 0
            ? Math.min(60, (totalExtractedRoots / maxComments) * 60)
            : expectedTotal > 0
            ? Math.min(60, (totalExtractedRoots / expectedTotal) * 60)
            : 35;
          await flushBatch(
            pct,
            `Aguardando YouTube carregar mais comentários... (${currentThreadsCount} carregados, tentativa ${stallCount}/${maxStallAttempts})`
          );

          await delay(Math.min(1500, throttle + stallCount * 60));

          if (stallCount >= maxStallAttempts) {
            console.warn("[YT Extractor] Timeout aguardando continuação após várias tentativas.");
            break;
          }
        } else {
          // Nenhum continuationLoader: se persistir por 3 verificações, o YouTube encerrou os comentários
          if (stallCount >= 3) {
            console.log("[YT Extractor] Fim dos comentários principais detectado (continuationLoader ausente).");
            break;
          }
          window.scrollTo({ top: document.documentElement.scrollHeight, behavior: "instant" });
          window.dispatchEvent(new Event("scroll"));
          await delay(throttle);
        }
      } else {
        stallCount = 0;
        previousThreadsCount = currentThreadsCount;

        if (continuationLoader) {
          continuationLoader.scrollIntoView({ behavior: "instant", block: "center" });
        } else {
          window.scrollTo({ top: document.documentElement.scrollHeight, behavior: "instant" });
        }
        window.dispatchEvent(new Event("scroll"));
        await delay(throttle);
      }
    }

    // Flush de encerramento da Fase 1
    await flushBatch(
      65,
      `Comentários principais carregados (${totalExtractedRoots} tópicos). Iniciando expansão de respostas...`
    );

    // =========================================================================
    // FASE 2: EXPANSÃO EXAUSTIVA DE RESPOSTAS (REPLIES) & STREAMING
    // =========================================================================
    if (!shouldStop) {
      let allThreads = Array.from(document.querySelectorAll(SELECTORS.commentThread));
      if (maxComments > 0 && allThreads.length > maxComments) {
        allThreads = allThreads.slice(0, maxComments);
      }
      
      const threadsWithReplies = allThreads.filter((t) => {
        const hasReplyBtn = getThreadReplyButtons(t).length > 0;
        const hasRepliesContainer = t.querySelector(SELECTORS.repliesRenderer) !== null;
        return hasReplyBtn || hasRepliesContainer;
      });

      console.log(`[YT Extractor] FASE 2: ${threadsWithReplies.length} tópicos com respostas identificados de ${allThreads.length} totais.`);

      for (let i = 0; i < threadsWithReplies.length && !shouldStop; i++) {
        const thread = threadsWithReplies[i];

        // 1. Rola o thread para o centro (indispensável para o YouTube renderizar e buscar respostas)
        thread.scrollIntoView({ behavior: "instant", block: "center" });
        await delay(100);

        // 2. Clica no botão "Ver respostas" visível
        const replyButtons = getThreadReplyButtons(thread);
        for (const btn of replyButtons) {
          if (!shouldStop) {
            btn.click();
            await delay(throttle);
          }
        }

        // 3. Pagina "Mostrar mais respostas" até esgotar
        let paginator = getThreadReplyPaginator(thread);
        let moreAttempts = 0;

        while (paginator && !shouldStop && moreAttempts < 50) {
          const prevReplyCount = thread.querySelectorAll(SELECTORS.commentRenderer).length;
          paginator.click();
          
          // Aguarda chegada de novos nós no DOM (polling ativo até 2s)
          let waitCycles = 0;
          while (waitCycles < 8) {
            await delay(250);
            const currentReplyElements = thread.querySelectorAll(SELECTORS.commentRenderer);
            if (currentReplyElements.length > prevReplyCount) {
              break;
            }
            waitCycles++;
          }

          const currentReplyElements = thread.querySelectorAll(SELECTORS.commentRenderer);
          if (currentReplyElements.length === prevReplyCount) {
            break; // Botão travado ou sem novas respostas
          }

          paginator = getThreadReplyPaginator(thread);
          moreAttempts++;
        }

        // 4. Clica em expansores de texto "Ler mais" deste thread
        const expanders = thread.querySelectorAll(SELECTORS.commentExpander);
        for (const exp of expanders) {
          if (exp && exp.offsetParent !== null) {
            exp.click();
          }
        }

        // 5. Extrai as respostas deste thread
        const mainCommentEl = thread.querySelector("#comment");
        const mainComment = parseComment(mainCommentEl, false);
        const rootId = mainComment ? (mainComment.rawId || mainComment.id) : null;

        const repliesContainer = thread.querySelector(SELECTORS.repliesRenderer);
        if (repliesContainer && rootId) {
          const replyEls = repliesContainer.querySelectorAll(SELECTORS.commentRenderer);
          for (const repEl of replyEls) {
            const rep = parseComment(repEl, true);
            if (rep) {
              const repId = rep.rawId || rep.id;
              if (!knownCommentIds.has(repId)) {
                knownCommentIds.add(repId);
                rep.parentId = rootId;
                if (allExtractedRootsMap.has(rootId)) {
                  allExtractedRootsMap.get(rootId).replies.push(rep);
                }
                pendingBatch.push(rep);
                totalRepliesFound++;
              }
            }
          }
        }

        // Flush periódico para streaming no IndexedDB
        if (pendingBatch.length >= 15 || i === threadsWithReplies.length - 1) {
          const pct = Math.min(98, 65 + Math.round(((i + 1) / threadsWithReplies.length) * 33));
          await flushBatch(
            pct,
            `Expandindo respostas (${i + 1}/${threadsWithReplies.length} tópicos)... ${knownCommentIds.size} no banco (${totalRepliesFound} respostas)`
          );
          sendProgress(
            pct,
            `Expandindo respostas (${i + 1}/${threadsWithReplies.length} tópicos)...`,
            totalExtractedRoots,
            totalRepliesFound
          );
        }
      }
    }

    // =========================================================================
    // FASE 3: CONSOLIDAÇÃO & ENCERRAMENTO
    // =========================================================================
    await flushBatch(100, shouldStop ? "Extração pausada/interrompida" : "Extração concluída com sucesso!");

    const finalComments = Array.from(allExtractedRootsMap.values());
    sendProgress(
      100,
      shouldStop ? "Extração interrompida pelo usuário." : "Extração concluída!",
      finalComments.length,
      totalRepliesFound
    );

    chrome.runtime.sendMessage({
      action: "commentsBatch",
      videoId,
      videoInfo: getVideoInfo(),
      comments: [],
      progress: {
        percentage: 100,
        message: shouldStop
          ? `Parado pelo usuário (${knownCommentIds.size} comentários e respostas salvos)`
          : `Concluído! ${knownCommentIds.size} comentários e respostas salvos no banco.`
      },
      isFinished: true,
      stoppedReason: shouldStop,
    }).catch(() => {});

    isRunning = false;
    console.log("[YT Extractor] Processo finalizado com sucesso. Total de IDs indexados:", knownCommentIds.size);

    return {
      success: true,
      stoppedEarly: shouldStop,
      data: {
        videoInfo: getVideoInfo(),
        extractionInfo: {
          extractedAt: new Date().toISOString(),
          totalComments: finalComments.length,
          totalReplies: totalRepliesFound,
          throttleMs: throttle,
          maxComments: maxComments,
          stoppedEarly: shouldStop,
        },
        comments: finalComments,
      },
    };
  }

  // Chrome Runtime Messaging Listener
  chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.action === "getVideoInfo") {
      sendResponse(getVideoInfo());
      return true;
    }

    if (message.action === "expandComments") {
      const throttle = message.throttle || 500;
      const maxComments = message.maxComments || 0;
      shouldStop = false;
      const vInfo = getVideoInfo();

      runStreamingExtraction({
        videoId: vInfo.videoId,
        throttle,
        maxComments,
        autoPause: true,
        sortOrder: "newest",
      }).then((result) => {
        sendResponse(result);
      }).catch((err) => {
        sendResponse({ success: false, error: err.message });
      });

      return true; // Keep channel open for async response
    }

    if (message.action === "stopExpanding") {
      shouldStop = true;
      sendResponse({ success: true });
      return true;
    }

    if (message.action === "startExtraction") {
      if (message.existingIds && Array.isArray(message.existingIds)) {
        message.existingIds.forEach((id) => knownCommentIds.add(id));
      }
      shouldStop = false;
      runStreamingExtraction(message);
      sendResponse({ started: true });
      return true;
    }

    if (message.action === "pauseExtraction" || message.action === "stopExtraction") {
      shouldStop = true;
      sendResponse({ stopping: true });
      return true;
    }

    return false;
  });

  console.log("[YT Extractor] Modern Content Script loaded and listening.");
})();
