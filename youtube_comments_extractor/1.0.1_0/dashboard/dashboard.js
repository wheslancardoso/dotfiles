/**
 * YouTube Comments Extractor - Dashboard Controller
 * Manages extraction life-cycle, live database streaming, UI updates, and exports
 */

document.addEventListener("DOMContentLoaded", async () => {
  // DOM Elements
  const openTabsListEl = document.getElementById("open-tabs-list");
  const savedVideosListEl = document.getElementById("saved-videos-list");
  const refreshTabsBtn = document.getElementById("refresh-tabs-btn");
  const clearAllDbBtn = document.getElementById("clear-all-db-btn");

  const videoTitleEl = document.getElementById("video-title");
  const videoChannelEl = document.getElementById("video-channel");
  const videoIdTagEl = document.getElementById("video-id-tag");
  const videoReportedCountEl = document.getElementById("video-reported-count");
  const videoUrlLinkEl = document.getElementById("video-url-link");

  const statusPillEl = document.getElementById("status-pill");
  const rateCounterEl = document.getElementById("rate-counter");

  const startBtn = document.getElementById("start-btn");
  const pauseBtn = document.getElementById("pause-btn");
  const stopBtn = document.getElementById("stop-btn");

  const throttleInput = document.getElementById("throttle-input");
  const maxCommentsInput = document.getElementById("max-comments-input");
  const sortOrderSelect = document.getElementById("sort-order-select");
  const autoPauseInput = document.getElementById("auto-pause-input");

  const progressBarFill = document.getElementById("progress-bar-fill");
  const progressMessage = document.getElementById("progress-message");
  const progressPercentage = document.getElementById("progress-percentage");

  const statTotalEl = document.getElementById("stat-total");
  const statRootsEl = document.getElementById("stat-roots");
  const statRepliesEl = document.getElementById("stat-replies");

  const exportLlmBtn = document.getElementById("export-llm-btn");
  const copyLlmBtn = document.getElementById("copy-llm-btn");
  const exportJsonlBtn = document.getElementById("export-jsonl-btn");
  const exportJsonBtn = document.getElementById("export-json-btn");
  const exportCsvBtn = document.getElementById("export-csv-btn");

  const feedContainerEl = document.getElementById("comments-feed-container");
  const feedCountBadgeEl = document.getElementById("feed-count-badge");
  const searchInput = document.getElementById("search-input");
  const sortSelect = document.getElementById("sort-select");

  const toastEl = document.getElementById("toast");

  // State
  let currentVideo = null;
  let currentTargetTabId = null;
  let extractionState = "idle"; // "idle" | "running" | "paused" | "completed"
  let commentsRateTracker = { lastCount: 0, lastTime: Date.now() };
  let cachedComments = [];

  // Helper Toast
  function showToast(message, duration = 3000) {
    toastEl.textContent = message;
    toastEl.classList.remove("hidden");
    toastEl.style.opacity = "1";
    setTimeout(() => {
      toastEl.style.opacity = "0";
      setTimeout(() => toastEl.classList.add("hidden"), 300);
    }, duration);
  }

  // Update Status Badge
  function updateStatus(state, customLabel = null) {
    extractionState = state;
    statusPillEl.className = "status-pill";

    if (state === "running") {
      statusPillEl.classList.add("status-running");
      statusPillEl.textContent = customLabel || "Extraindo";
      startBtn.disabled = true;
      pauseBtn.disabled = false;
      stopBtn.disabled = false;
    } else if (state === "paused") {
      statusPillEl.classList.add("status-paused");
      statusPillEl.textContent = customLabel || "Pausado";
      startBtn.disabled = false;
      startBtn.innerHTML = `<span class="btn-icon">▶️</span> Retomar Extração`;
      pauseBtn.disabled = true;
      stopBtn.disabled = false;
    } else if (state === "completed") {
      statusPillEl.classList.add("status-completed");
      statusPillEl.textContent = customLabel || "Concluído";
      startBtn.disabled = false;
      startBtn.innerHTML = `<span class="btn-icon">🔄</span> Extrair Novamente`;
      pauseBtn.disabled = true;
      stopBtn.disabled = true;
    } else {
      statusPillEl.classList.add("status-idle");
      statusPillEl.textContent = customLabel || "Pronto";
      startBtn.disabled = false;
      startBtn.innerHTML = `<span class="btn-icon">▶️</span> Iniciar Extração`;
      pauseBtn.disabled = true;
      stopBtn.disabled = true;
    }
  }

  // Update Progress Display
  function updateProgress(percent, message) {
    progressBarFill.style.width = `${Math.min(100, Math.max(0, percent))}%`;
    progressPercentage.textContent = `${Math.round(percent)}%`;
    if (message) progressMessage.textContent = message;
  }

  // Calculate comments extraction speed
  function updateRate(currentCount) {
    const now = Date.now();
    const elapsedSec = (now - commentsRateTracker.lastTime) / 1000;
    if (elapsedSec >= 1.5) {
      const diff = currentCount - commentsRateTracker.lastCount;
      const rate = diff > 0 ? (diff / elapsedSec).toFixed(1) : "0.0";
      rateCounterEl.textContent = `${rate} com/s`;
      commentsRateTracker = { lastCount: currentCount, lastTime: now };
    }
  }

  // Refresh Open YouTube Tabs
  async function loadOpenYouTubeTabs() {
    try {
      const tabs = await chrome.tabs.query({ url: "*://*.youtube.com/watch*" });
      openTabsListEl.innerHTML = "";

      if (tabs.length === 0) {
        openTabsListEl.innerHTML = `<p class="empty-state">Nenhum vídeo aberto no navegador.</p>`;
        return;
      }

      for (const tab of tabs) {
        const urlParams = new URL(tab.url).searchParams;
        const videoId = urlParams.get("v") || "desconhecido";
        const title = tab.title.replace(" - YouTube", "").trim();

        const card = document.createElement("div");
        card.className = "video-card-item";
        if (currentVideo && currentVideo.videoId === videoId) {
          card.classList.add("active");
        }

        card.innerHTML = `
          <div class="video-item-title">${escapeHtml(title)}</div>
          <div class="video-item-meta">
            <span>Aba ID: ${tab.id}</span>
            <span>${videoId}</span>
          </div>
        `;

        card.addEventListener("click", () => {
          selectVideo(
            {
              videoId,
              title,
              url: tab.url,
            },
            tab.id
          );
        });

        openTabsListEl.appendChild(card);
      }
    } catch (err) {
      console.error("[Dashboard] Error querying tabs:", err);
    }
  }

  // Load Saved Videos from IndexedDB
  async function loadSavedVideos() {
    try {
      const videos = await window.commentsDB.getAllVideos();
      savedVideosListEl.innerHTML = "";

      if (videos.length === 0) {
        savedVideosListEl.innerHTML = `<p class="empty-state">Nenhum histórico salvo ainda.</p>`;
        return;
      }

      for (const v of videos) {
        const card = document.createElement("div");
        card.className = "video-card-item";
        if (currentVideo && currentVideo.videoId === v.videoId) {
          card.classList.add("active");
        }

        const counts = await window.commentsDB.getCommentCount(v.videoId);

        card.innerHTML = `
          <div class="video-item-title">${escapeHtml(v.title || v.videoId)}</div>
          <div class="video-item-meta">
            <span>💾 ${counts.total} salvos</span>
            <span>${v.channel || ""}</span>
          </div>
        `;

        card.addEventListener("click", () => {
          selectVideo(v, null);
        });

        savedVideosListEl.appendChild(card);
      }
    } catch (err) {
      console.error("[Dashboard] Error loading saved videos:", err);
    }
  }

  // Select Video to inspect/extract
  async function selectVideo(videoData, tabId = null) {
    currentVideo = videoData;
    currentTargetTabId = tabId;

    // Fetch fresher info from DB if exists
    const dbRecord = await window.commentsDB.getVideo(videoData.videoId);
    if (dbRecord) {
      currentVideo = { ...dbRecord, ...videoData };
    }

    // Update Header UI
    videoTitleEl.textContent = currentVideo.title || "Vídeo sem título";
    videoChannelEl.textContent = currentVideo.channel || "YouTube";
    videoIdTagEl.textContent = `ID: ${currentVideo.videoId}`;
    videoReportedCountEl.textContent = `Total YouTube: ${currentVideo.totalComments || "Detectando..."}`;
    videoUrlLinkEl.href = currentVideo.url || `https://www.youtube.com/watch?v=${currentVideo.videoId}`;

    // Reload counts & feed
    await refreshStatsAndFeed();

    // If tabId is not provided, try to find an open tab for this videoId
    if (!currentTargetTabId) {
      const tabs = await chrome.tabs.query({ url: `*://*.youtube.com/watch*v=${currentVideo.videoId}*` });
      if (tabs.length > 0) {
        currentTargetTabId = tabs[0].id;
      }
    }

    updateStatus(currentVideo.status === "running" ? "running" : "idle");
    loadOpenYouTubeTabs();
    loadSavedVideos();
  }

  // Refresh Stats and Live Feed for Selected Video
  async function refreshStatsAndFeed() {
    if (!currentVideo) return;

    const counts = await window.commentsDB.getCommentCount(currentVideo.videoId);
    statTotalEl.textContent = counts.total.toLocaleString("pt-BR");
    statRootsEl.textContent = counts.roots.toLocaleString("pt-BR");
    statRepliesEl.textContent = counts.replies.toLocaleString("pt-BR");

    updateRate(counts.total);

    // Load comments into feed
    const hierarchical = await window.commentsDB.getHierarchicalComments(currentVideo.videoId);
    cachedComments = hierarchical.roots;
    renderCommentsFeed();
  }

  // Render Comments Feed with Filters
  function renderCommentsFeed() {
    feedContainerEl.innerHTML = "";
    feedCountBadgeEl.textContent = `${cachedComments.length} tópicos`;

    if (cachedComments.length === 0) {
      feedContainerEl.innerHTML = `<div class="empty-feed"><p>Nenhum comentário gravado ainda. Inicie a extração acima.</p></div>`;
      return;
    }

    const searchTerm = searchInput.value.toLowerCase().trim();
    const sortBy = sortSelect.value;

    let filtered = cachedComments.filter((c) => {
      if (!searchTerm) return true;
      const text = (c.content?.text || "").toLowerCase();
      const author = (c.author?.name || "").toLowerCase();
      return text.includes(searchTerm) || author.includes(searchTerm);
    });

    if (sortBy === "likes") {
      filtered.sort((a, b) => (b.likeCount || 0) - (a.likeCount || 0));
    } else if (sortBy === "replies") {
      filtered.sort((a, b) => (b.replies?.length || 0) - (a.replies?.length || 0));
    }

    const slice = filtered.slice(0, 100); // Render up to 100 for smooth DOM performance

    for (const c of slice) {
      const card = document.createElement("div");
      card.className = "comment-card";
      if (c.replies && c.replies.length > 0) {
        card.classList.add("has-replies");
      }

      const pinned = c.isPinned ? `<span class="badge-pinned">📌 Fixado</span>` : "";
      const heart = c.hasCreatorHeart ? `<span class="badge-heart">❤️ Coração</span>` : "";
      const owner = c.author?.isOwner ? `<span class="badge-owner">👑 Criador</span>` : "";

      let repliesHtml = "";
      if (c.replies && c.replies.length > 0) {
        repliesHtml = `<div class="comment-replies-summary">↳ ${c.replies.length} resposta(s) indexada(s)</div>`;
      }

      card.innerHTML = `
        <div class="comment-header">
          <div class="comment-author">
            <span>@${escapeHtml(c.author?.name || "Desconhecido")}</span>
            ${owner} ${heart} ${pinned}
          </div>
          <div class="comment-meta">
            <span>${c.publishedTime || ""}</span>
            <span>👍 ${(c.likeCount || 0).toLocaleString()}</span>
          </div>
        </div>
        <div class="comment-text">${escapeHtml(c.content?.text || "")}</div>
        ${repliesHtml}
      `;

      feedContainerEl.appendChild(card);
    }
  }

  // --- Extraction Actions ---

  async function ensureTargetTab() {
    if (!currentVideo) {
      showToast("Selecione um vídeo primeiro.");
      return null;
    }

    if (currentTargetTabId) {
      try {
        const tab = await chrome.tabs.get(currentTargetTabId);
        if (tab && tab.url && tab.url.includes(currentVideo.videoId)) {
          return currentTargetTabId;
        }
      } catch (e) {
        currentTargetTabId = null;
      }
    }

    // Try finding open tab
    const tabs = await chrome.tabs.query({ url: `*://*.youtube.com/watch*v=${currentVideo.videoId}*` });
    if (tabs.length > 0) {
      currentTargetTabId = tabs[0].id;
      return currentTargetTabId;
    }

    // Open in background tab if none found
    const newTab = await chrome.tabs.create({
      url: currentVideo.url || `https://www.youtube.com/watch?v=${currentVideo.videoId}`,
      active: false,
    });
    currentTargetTabId = newTab.id;
    showToast("Abrindo vídeo em aba de suporte para extração...");
    await new Promise((res) => setTimeout(res, 3000));
    return currentTargetTabId;
  }

  async function startExtraction() {
    const tabId = await ensureTargetTab();
    if (!tabId) return;

    const throttle = parseInt(throttleInput.value) || 600;
    const maxComments = parseInt(maxCommentsInput.value) || 0;
    const sortOrder = sortOrderSelect ? sortOrderSelect.value : "newest";
    const autoPause = autoPauseInput ? autoPauseInput.checked : true;

    // Get existing IDs from DB so content script can skip them
    const existingIds = Array.from(await window.commentsDB.getExistingCommentIds(currentVideo.videoId));

    updateStatus("running", "Iniciando...");
    updateProgress(5, "Conectando ao YouTube...");

    await window.commentsDB.upsertVideo({
      ...currentVideo,
      status: "running",
      throttleMs: throttle,
      maxComments: maxComments,
    });

    try {
      await chrome.tabs.sendMessage(tabId, {
        action: "startExtraction",
        videoId: currentVideo.videoId,
        throttle,
        maxComments,
        sortOrder,
        autoPause,
        existingIds,
      });
      showToast("Extração rodando com persistência em background!");
    } catch (err) {
      console.error("[Dashboard] Error starting extraction:", err);
      showToast("Erro ao comunicar com a aba do YouTube. Recarregue a página do vídeo.");
      updateStatus("idle");
    }
  }

  async function pauseExtraction() {
    if (!currentTargetTabId) return;
    updateStatus("paused");
    updateProgress(progressBarFill.style.width, "Extração pausada pelo usuário");

    try {
      await chrome.tabs.sendMessage(currentTargetTabId, { action: "pauseExtraction" });
      if (currentVideo) {
        await window.commentsDB.upsertVideo({ ...currentVideo, status: "paused" });
      }
      showToast("Extração pausada. Você pode retomar a qualquer momento.");
    } catch (e) {
      console.warn("Pause error:", e);
    }
  }

  async function stopExtraction() {
    if (!currentTargetTabId) return;
    updateStatus("completed", "Finalizado");
    updateProgress(100, "Extração finalizada pelo usuário");

    try {
      await chrome.tabs.sendMessage(currentTargetTabId, { action: "stopExtraction" });
      if (currentVideo) {
        await window.commentsDB.upsertVideo({ ...currentVideo, status: "completed" });
      }
      showToast("Extração concluída e consolidada no DB!");
    } catch (e) {
      console.warn("Stop error:", e);
    }
  }

  // --- Message Listener for Streaming Batches from Content Script ---
  chrome.runtime.onMessage.addListener(async (message) => {
    if (message.action === "commentsBatch") {
      const { videoId, videoInfo, comments, progress, isFinished, stoppedReason } = message;

      if (!currentVideo || currentVideo.videoId === videoId) {
        // Upsert video details
        if (videoInfo) {
          currentVideo = { ...currentVideo, ...videoInfo };
          videoTitleEl.textContent = currentVideo.title;
          videoChannelEl.textContent = currentVideo.channel;
          videoReportedCountEl.textContent = `Total YouTube: ${currentVideo.totalComments || "-"}`;
        }

        // Persist batch to IndexedDB
        if (comments && comments.length > 0) {
          await window.commentsDB.upsertCommentsBatch(videoId, comments);
        }

        // Update progress
        if (progress) {
          updateProgress(progress.percentage, progress.message);
        }

        await refreshStatsAndFeed();

        if (isFinished) {
          updateStatus("completed", stoppedReason ? "Interrompido" : "Concluído");
          showToast(`Finalizado! ${statTotalEl.textContent} comentários gravados com sucesso.`);
          loadSavedVideos();
        }
      }
    }

    if (message.action === "commentsDisabled") {
      updateStatus("idle", "Desativado");
      updateProgress(0, "Comentários desativados pelo criador para este vídeo.");
      showToast("Aviso: Os comentários estão desativados para este vídeo no YouTube.", 5000);
    }

    if (message.action === "videoNavigated") {
      // Reload open tabs when user navigates inside YouTube
      loadOpenYouTubeTabs();
    }
  });

  // --- Export Handlers ---

  exportLlmBtn.addEventListener("click", async () => {
    if (!currentVideo) return showToast("Nenhum vídeo selecionado.");
    const data = await window.commentsDB.getHierarchicalComments(currentVideo.videoId);
    if (data.totalComments === 0) return showToast("Sem comentários gravados para exportar.");

    const markdown = window.Exporter.generateLLMContextMarkdown(currentVideo, data);
    const filename = window.Exporter.safeFilename(currentVideo.title, "md");
    window.Exporter.downloadFile(markdown, filename, "text/markdown;charset=utf-8;");
    showToast("Arquivo Markdown para IA baixado com sucesso!");
  });

  copyLlmBtn.addEventListener("click", async () => {
    if (!currentVideo) return showToast("Nenhum vídeo selecionado.");
    const data = await window.commentsDB.getHierarchicalComments(currentVideo.videoId);
    if (data.totalComments === 0) return showToast("Sem comentários para copiar.");

    const markdown = window.Exporter.generateLLMContextMarkdown(currentVideo, data);
    await navigator.clipboard.writeText(markdown);
    showToast("Contexto formatado para IA copiado para a Área de Transferência!");
  });

  exportJsonlBtn.addEventListener("click", async () => {
    if (!currentVideo) return showToast("Nenhum vídeo selecionado.");
    const data = await window.commentsDB.getHierarchicalComments(currentVideo.videoId);
    if (data.totalComments === 0) return showToast("Sem comentários gravados para exportar.");

    const jsonl = window.Exporter.generateJSONL(currentVideo, data);
    const filename = window.Exporter.safeFilename(currentVideo.title, "jsonl");
    window.Exporter.downloadFile(jsonl, filename, "application/x-jsonlines;charset=utf-8;");
    showToast("Arquivo JSONL para RAG/IA baixado!");
  });

  exportJsonBtn.addEventListener("click", async () => {
    if (!currentVideo) return showToast("Nenhum vídeo selecionado.");
    const data = await window.commentsDB.getHierarchicalComments(currentVideo.videoId);
    if (data.totalComments === 0) return showToast("Sem comentários gravados.");

    const json = window.Exporter.generateHierarchicalJSON(currentVideo, data);
    const filename = window.Exporter.safeFilename(currentVideo.title, "json");
    window.Exporter.downloadFile(json, filename, "application/json;charset=utf-8;");
    showToast("JSON hierárquico exportado!");
  });

  exportCsvBtn.addEventListener("click", async () => {
    if (!currentVideo) return showToast("Nenhum vídeo selecionado.");
    const data = await window.commentsDB.getHierarchicalComments(currentVideo.videoId);
    if (data.totalComments === 0) return showToast("Sem comentários para exportar.");

    const csv = window.Exporter.generateEnhancedCSV(currentVideo, data);
    const filename = window.Exporter.safeFilename(currentVideo.title, "csv");
    window.Exporter.downloadFile(csv, filename, "text/csv;charset=utf-8;");
    showToast("CSV enriquecido exportado!");
  });

  // UI Event Listeners
  startBtn.addEventListener("click", startExtraction);
  pauseBtn.addEventListener("click", pauseExtraction);
  stopBtn.addEventListener("click", stopExtraction);
  refreshTabsBtn.addEventListener("click", loadOpenYouTubeTabs);

  clearAllDbBtn.addEventListener("click", async () => {
    if (confirm("Deseja realmente limpar todo o banco de dados da extensão?")) {
      await window.commentsDB.clearAll();
      showToast("Banco de dados resetado.");
      window.location.reload();
    }
  });

  searchInput.addEventListener("input", renderCommentsFeed);
  sortSelect.addEventListener("change", renderCommentsFeed);

  // Helper HTML Escaper
  function escapeHtml(str) {
    if (!str) return "";
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  // --- Auto Initialization ---
  await window.commentsDB.init();
  await loadOpenYouTubeTabs();
  await loadSavedVideos();

  // Check query params if opened directly from popup
  const params = new URLSearchParams(window.location.search);
  const paramVideoId = params.get("videoId");
  const paramTabId = params.get("tabId") ? parseInt(params.get("tabId")) : null;

  if (paramVideoId) {
    selectVideo({ videoId: paramVideoId }, paramTabId);
  } else {
    // Select first open tab if available
    const tabs = await chrome.tabs.query({ url: "*://*.youtube.com/watch*" });
    if (tabs.length > 0) {
      const urlParams = new URL(tabs[0].url).searchParams;
      selectVideo(
        {
          videoId: urlParams.get("v") || "",
          title: tabs[0].title.replace(" - YouTube", ""),
          url: tabs[0].url,
        },
        tabs[0].id
      );
    }
  }
});
