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

  async function scrollToComments() {
    let section = document.querySelector(SELECTORS.commentsSection);
    if (!section) {
      window.scrollTo(0, 750);
      await delay(1200);
      section = document.querySelector(SELECTORS.commentsSection);
    }
    if (section) {
      section.scrollIntoView({ behavior: "smooth", block: "start" });
      await delay(800);
      return true;
    }
    return false;
  }

  // Expand replies for a specific thread element
  async function expandThreadReplies(thread, throttle) {
    const threadKey = thread.getAttribute("id") || thread.querySelector("#comment")?.textContent?.substring(0, 50);
    if (expandedThreadIds.has(threadKey)) return;

    // Click "View replies" button
    const replyButtons = thread.querySelectorAll(SELECTORS.replyButton);
    for (const btn of replyButtons) {
      if (btn && !shouldStop) {
        btn.click();
        await delay(throttle);
      }
    }

    // Expand additional replies pagination ("Show more replies")
    let moreReplies = thread.querySelector(SELECTORS.showMoreReplies);
    let attempts = 0;
    while (moreReplies && !shouldStop && attempts < 30) {
      moreReplies.click();
      await delay(throttle);
      moreReplies = thread.querySelector(SELECTORS.showMoreReplies);
      attempts++;
    }

    // Expand "Read more" truncated text expanders
    const expanders = thread.querySelectorAll(SELECTORS.commentExpander);
    for (const exp of expanders) {
      if (exp && exp.offsetParent !== null) {
        exp.click();
      }
    }

    expandedThreadIds.add(threadKey);
  }

  // Main Streaming Extraction Loop
  async function runStreamingExtraction(options) {
    const { videoId, throttle = 600, maxComments = 0 } = options;
    isRunning = true;
    shouldStop = false;

    console.log("[YT Extractor] Starting streaming extraction for video:", videoId);

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

    const loaded = await scrollToComments();
    if (!loaded) {
      console.warn("[YT Extractor] Seção de comentários não detectada ainda.");
    }

    let previousThreadsCount = 0;
    let sameCountAttempts = 0;
    const maxSameCount = 6;
    let totalExtractedRoots = 0;
    let pendingBatch = [];

    async function flushBatch(percentage, message) {
      if (pendingBatch.length > 0) {
        chrome.runtime.sendMessage({
          action: "commentsBatch",
          videoId,
          videoInfo: getVideoInfo(),
          comments: pendingBatch,
          progress: { percentage, message },
          isFinished: false,
        });
        pendingBatch = [];
      }
    }

    while (!shouldStop) {
      const threadElements = document.querySelectorAll(SELECTORS.commentThread);
      const currentThreadsCount = threadElements.length;

      // Process newly discovered threads
      for (let i = 0; i < threadElements.length && !shouldStop; i++) {
        const thread = threadElements[i];
        const mainCommentEl = thread.querySelector("#comment");
        if (!mainCommentEl) continue;

        const mainComment = parseComment(mainCommentEl, false);
        if (!mainComment) continue;

        const rootId = mainComment.rawId || mainComment.id;

        // Check if we need to expand replies
        await expandThreadReplies(thread, Math.min(400, throttle));

        // Add root comment if not yet known
        if (!knownCommentIds.has(rootId)) {
          knownCommentIds.add(rootId);
          pendingBatch.push(mainComment);
          totalExtractedRoots++;
        }

        // Process replies in thread
        const repliesContainer = thread.querySelector(SELECTORS.repliesRenderer);
        if (repliesContainer) {
          const replyEls = repliesContainer.querySelectorAll(SELECTORS.commentRenderer);
          for (const repEl of replyEls) {
            const rep = parseComment(repEl, true);
            if (rep) {
              const repId = rep.rawId || rep.id;
              if (!knownCommentIds.has(repId)) {
                knownCommentIds.add(repId);
                rep.parentId = rootId;
                pendingBatch.push(rep);
              }
            }
          }
        }

        // Flush batch every 15 items for silky smooth streaming into IndexedDB
        if (pendingBatch.length >= 15) {
          const pct = maxComments > 0 ? Math.min(95, (totalExtractedRoots / maxComments) * 100) : 50;
          await flushBatch(pct, `Coletando... (${knownCommentIds.size} salvos no DB)`);
        }

        if (maxComments > 0 && totalExtractedRoots >= maxComments) {
          break;
        }
      }

      // Check limits
      if (maxComments > 0 && totalExtractedRoots >= maxComments) {
        await flushBatch(100, `Limite atingido (${totalExtractedRoots} comentários)`);
        break;
      }

      // Check bottom termination condition
      if (currentThreadsCount === previousThreadsCount) {
        sameCountAttempts++;
        if (sameCountAttempts >= maxSameCount) {
          await flushBatch(100, `Todos os comentários foram carregados`);
          break;
        }
      } else {
        sameCountAttempts = 0;
      }

      previousThreadsCount = currentThreadsCount;

      // Scroll down for more comments
      window.scrollTo(0, document.documentElement.scrollHeight);
      await delay(throttle);

      await flushBatch(
        maxComments > 0 ? Math.min(90, (totalExtractedRoots / maxComments) * 100) : 60,
        `Rolando página... (${knownCommentIds.size} comentários no banco)`
      );
    }

    // Final flush
    await flushBatch(100, shouldStop ? "Extração pausada/interrompida" : "Extração concluída!");

    chrome.runtime.sendMessage({
      action: "commentsBatch",
      videoId,
      videoInfo: getVideoInfo(),
      comments: [],
      progress: { percentage: 100, message: shouldStop ? "Parado" : "Concluído!" },
      isFinished: true,
      stoppedReason: shouldStop,
    });

    isRunning = false;
    console.log("[YT Extractor] Streaming extraction finished. Total IDs indexed:", knownCommentIds.size);
  }

  // Chrome Runtime Messaging Listener
  chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.action === "getVideoInfo") {
      sendResponse(getVideoInfo());
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
