// Popup script for YouTube Comments Extractor (1-Click Simple Workflow + LLM Exporter)

document.addEventListener("DOMContentLoaded", async () => {
  const notYouTubeEl = document.getElementById("not-youtube");
  const youtubeDetectedEl = document.getElementById("youtube-detected");
  const videoTitleEl = document.getElementById("video-title");
  const throttleInput = document.getElementById("throttle");
  const maxCommentsInput = document.getElementById("max-comments");
  const progressSection = document.getElementById("progress-section");
  const progressFill = document.getElementById("progress-fill");
  const progressText = document.getElementById("progress-text");
  const statsEl = document.getElementById("stats");
  const commentCountEl = document.getElementById("comment-count");
  const replyCountEl = document.getElementById("reply-count");
  const expandBtn = document.getElementById("expand-btn");
  const stopBtn = document.getElementById("stop-btn");
  const exportLlmBtn = document.getElementById("export-llm-btn");
  const exportCsvBtn = document.getElementById("export-csv-btn");
  const exportBtn = document.getElementById("export-btn");
  const errorEl = document.getElementById("error-message");
  const openDashboardBtn = document.getElementById("open-dashboard-btn");
  const openGeneralDashboardBtn = document.getElementById("open-general-dashboard-btn");

  let isRunning = false;
  let extractedData = null;
  let activeVideoId = null;
  let activeTabId = null;

  function showError(message) {
    if (!errorEl) return;
    errorEl.textContent = message;
    errorEl.classList.remove("hidden");
  }

  function hideError() {
    if (!errorEl) return;
    errorEl.classList.add("hidden");
  }

  function updateProgress(progress) {
    if (!progress) return;
    if (progressFill) progressFill.style.width = `${progress.percentage || 0}%`;
    if (progressText) progressText.textContent = progress.message || "";
    if (commentCountEl) commentCountEl.textContent = progress.commentCount || 0;
    if (replyCountEl) replyCountEl.textContent = progress.replyCount || 0;
  }

  async function getYouTubeTab() {
    try {
      const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
      if (activeTab && activeTab.url && activeTab.url.includes("youtube.com/watch")) {
        return activeTab;
      }
      const ytTabs = await chrome.tabs.query({ url: "*://*.youtube.com/watch*" });
      if (ytTabs && ytTabs.length > 0) {
        return ytTabs[0];
      }
    } catch (e) {}
    return null;
  }

  async function checkYouTubePage() {
    try {
      const tab = await getYouTubeTab();
      if (!tab || !tab.url || !tab.url.includes("youtube.com/watch")) {
        notYouTubeEl.classList.remove("hidden");
        youtubeDetectedEl.classList.add("hidden");
        return false;
      }

      const urlParams = new URL(tab.url).searchParams;
      activeVideoId = urlParams.get("v");
      activeTabId = tab.id;

      notYouTubeEl.classList.add("hidden");
      youtubeDetectedEl.classList.remove("hidden");
      videoTitleEl.textContent = tab.title ? tab.title.replace(" - YouTube", "") : "Vídeo do YouTube";

      return true;
    } catch (err) {
      showError("Erro ao detectar página: " + err.message);
      return false;
    }
  }

  async function sendMessageToContent(message) {
    const tab = await getYouTubeTab();
    if (!tab) throw new Error("Aba do YouTube não encontrada.");
    try {
      return await chrome.tabs.sendMessage(tab.id, message);
    } catch (err) {
      if (err.message && err.message.includes("Receiving end does not exist")) {
        // Aba do YouTube foi aberta antes da extensão ser recarregada.
        // Injeta automaticamente o content script na aba ativa e tenta novamente.
        if (chrome.scripting && chrome.scripting.executeScript) {
          await chrome.scripting.insertCSS({
            target: { tabId: tab.id },
            files: ["content/content.css"]
          }).catch(() => {});
          await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            files: ["content/content.js"]
          });
          await new Promise((r) => setTimeout(r, 400));
          return await chrome.tabs.sendMessage(tab.id, message);
        }
      }
      throw err;
    }
  }

  function countReplies(comments) {
    if (!comments || !Array.isArray(comments)) return 0;
    return comments.reduce((total, comment) => {
      return total + (comment.replies ? comment.replies.length : 0);
    }, 0);
  }

  async function startExpanding() {
    hideError();
    isRunning = true;
    extractedData = null;

    expandBtn.classList.add("hidden");
    stopBtn.classList.remove("hidden");
    exportLlmBtn.classList.add("hidden");
    exportCsvBtn.classList.add("hidden");
    exportBtn.classList.add("hidden");
    progressSection.classList.remove("hidden");
    statsEl.classList.remove("hidden");

    const throttle = parseInt(throttleInput.value) || 500;
    const maxComments = parseInt(maxCommentsInput.value) || 0;

    try {
      const response = await sendMessageToContent({
        action: "expandComments",
        throttle,
        maxComments,
      });

      if (response && response.success) {
        extractedData = response.data;
        const isStopped = response.stoppedEarly || response.data?.extractionInfo?.stoppedEarly;
        const msg = isStopped
          ? `Parado pelo usuário (dados parciais: ${response.data.comments.length} comentários)`
          : "Extração concluída com sucesso!";

        updateProgress({
          percentage: 100,
          message: msg,
          commentCount: response.data.comments.length,
          replyCount: countReplies(response.data.comments),
        });

        exportLlmBtn.classList.remove("hidden");
        exportCsvBtn.classList.remove("hidden");
        exportBtn.classList.remove("hidden");
      } else {
        showError(response?.error || "Erro durante a extração dos comentários.");
      }
    } catch (err) {
      showError(err.message || "Falha na comunicação com a página do YouTube.");
    } finally {
      isRunning = false;
      stopBtn.classList.add("hidden");
      expandBtn.classList.remove("hidden");
    }
  }

  async function stopExpanding() {
    try {
      progressText.textContent = "Interrompendo e gerando dados parciais...";
      await sendMessageToContent({ action: "stopExpanding" });
    } catch (err) {
      console.warn("Failed to stop:", err);
      isRunning = false;
      stopBtn.classList.add("hidden");
      expandBtn.classList.remove("hidden");
    }
  }

  // --- Export Handlers ---

  function exportToJSON() {
    if (!extractedData) return showError("Sem dados para exportar.");
    const blob = new Blob([JSON.stringify(extractedData, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    const safeTitle = (extractedData.videoInfo?.title || "youtube_comments").replace(/[^a-z0-9]/gi, "_").substring(0, 50);
    const timestamp = new Date().toISOString().split("T")[0];
    a.href = url;
    a.download = `youtube_comments_${safeTitle}_${timestamp}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  function exportToCSV() {
    if (!extractedData) return showError("Sem dados para exportar.");
    const escapeCsv = (str) => {
      if (str === null || str === undefined) return "";
      str = String(str);
      if (str.includes('"') || str.includes(",") || str.includes("\n")) {
        return '"' + str.replace(/"/g, '""') + '"';
      }
      return str;
    };

    const allComments = [];
    extractedData.comments.forEach((c) => {
      allComments.push({
        author: c.author?.name || "Desconhecido",
        text: c.content?.text || "",
        likes: c.likeCount || 0,
        replyCount: c.replies ? c.replies.length : 0,
        publishedTime: c.publishedTime || "",
        isReply: false,
        isEdited: c.isEdited ? "Sim" : "Não",
        isPinned: c.isPinned ? "Sim" : "Não",
        hasCreatorHeart: c.hasCreatorHeart ? "Sim" : "Não",
      });

      if (c.replies && c.replies.length > 0) {
        c.replies.forEach((r) => {
          allComments.push({
            author: r.author?.name || "Desconhecido",
            text: r.content?.text || "",
            likes: r.likeCount || 0,
            replyCount: 0,
            publishedTime: r.publishedTime || "",
            isReply: true,
            isEdited: r.isEdited ? "Sim" : "Não",
            isPinned: "Não",
            hasCreatorHeart: r.hasCreatorHeart ? "Sim" : "Não",
          });
        });
      }
    });

    const headers = ["Autor", "Texto", "Likes", "Respostas", "Data", "E Resposta?", "Editado?", "Fixado?", "Coracao?"];
    let csvContent = "\uFEFF" + headers.join(",") + "\n";

    allComments.forEach((c) => {
      const row = [
        escapeCsv(c.author),
        escapeCsv(c.text),
        c.likes,
        c.replyCount,
        escapeCsv(c.publishedTime),
        c.isReply ? "Sim" : "Não",
        c.isEdited,
        c.isPinned,
        c.hasCreatorHeart,
      ];
      csvContent += row.join(",") + "\n";
    });

    const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    const safeTitle = (extractedData.videoInfo?.title || "youtube_comments").replace(/[^a-z0-9]/gi, "_").substring(0, 50);
    const timestamp = new Date().toISOString().split("T")[0];
    a.href = url;
    a.download = `youtube_comments_${safeTitle}_${timestamp}.csv`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  function exportToLLMMarkdown() {
    if (!extractedData) return showError("Sem dados para exportar.");
    const v = extractedData.videoInfo || {};
    const comments = extractedData.comments || [];
    const totalReplies = countReplies(comments);

    let md = `---
title: "${v.title || "YouTube Comments"}"
channel: "${v.channel || "Desconhecido"}"
url: "${v.url || ""}"
total_root_comments: ${comments.length}
total_replies: ${totalReplies}
total_extracted: ${comments.length + totalReplies}
extracted_at: "${new Date().toISOString()}"
---

# 💬 Transcrição de Discussões: ${v.title || "Vídeo"}
> Canal: **${v.channel || "-"}** | URL: ${v.url || "-"}  
> Amostragem: **${comments.length}** tópicos principais e **${totalReplies}** respostas.

---

## 🌳 Árvore de Comentários & Respostas

`;

    comments.forEach((c, idx) => {
      const pinned = c.isPinned ? " 📌 [FIXADO]" : "";
      const heart = c.hasCreatorHeart ? " ❤️ [CORAÇÃO DO CRIADOR]" : "";
      const likes = c.likeCount > 0 ? ` (+${c.likeCount} likes)` : "";

      md += `### [${idx + 1}] @${c.author?.name || "Anônimo"}${likes}${pinned}${heart} — *${c.publishedTime || ""}*\n\n`;
      md += `${c.content?.text || ""}\n\n`;

      if (c.replies && c.replies.length > 0) {
        c.replies.forEach((r) => {
          const rLikes = r.likeCount > 0 ? ` (+${r.likeCount} likes)` : "";
          const rHeart = r.hasCreatorHeart ? " ❤️" : "";
          md += `> ↳ **@${r.author?.name || "Anônimo"}**${rLikes}${rHeart} (*${r.publishedTime || ""}*):\n`;
          md += `> ${r.content?.text ? r.content.text.replace(/\n/g, "\n> ") : ""}\n>\n`;
        });
      }

      md += `---\n\n`;
    });

    const blob = new Blob([md], { type: "text/markdown;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    const safeTitle = (v.title || "youtube_comments").replace(/[^a-z0-9]/gi, "_").substring(0, 50);
    const timestamp = new Date().toISOString().split("T")[0];
    a.href = url;
    a.download = `youtube_comments_${safeTitle}_${timestamp}.md`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  function openDashboard(videoId = null, tabId = null) {
    let url = chrome.runtime.getURL("dashboard/dashboard.html");
    if (videoId) {
      url += `?videoId=${encodeURIComponent(videoId)}`;
      if (tabId) url += `&tabId=${tabId}`;
    }
    chrome.tabs.create({ url });
    window.close();
  }

  // Event Listeners
  expandBtn.addEventListener("click", startExpanding);
  stopBtn.addEventListener("click", stopExpanding);
  exportBtn.addEventListener("click", exportToJSON);
  exportCsvBtn.addEventListener("click", exportToCSV);
  exportLlmBtn.addEventListener("click", exportToLLMMarkdown);

  if (openDashboardBtn) {
    openDashboardBtn.addEventListener("click", () => openDashboard(activeVideoId, activeTabId));
  }
  if (openGeneralDashboardBtn) {
    openGeneralDashboardBtn.addEventListener("click", () => openDashboard());
  }

  // Listen for progress updates from content script
  chrome.runtime.onMessage.addListener((message) => {
    if (message.action === "progressUpdate") {
      updateProgress(message.progress);
    }
  });

  // Init
  const isPage = await checkYouTubePage();
  if (isPage) {
    try {
      const status = await sendMessageToContent({ action: "getStatus" });
      if (status && status.isRunning) {
        isRunning = true;
        expandBtn.classList.add("hidden");
        stopBtn.classList.remove("hidden");
        progressSection.classList.remove("hidden");
        statsEl.classList.remove("hidden");
        updateProgress({
          percentage: 50,
          message: "Extração em andamento em segundo plano...",
          commentCount: status.knownCount || 0,
          replyCount: 0
        });
      }
    } catch (e) {}
  }
});

