// Popup script - Lightweight launcher for YouTube Comments Extractor

document.addEventListener("DOMContentLoaded", async () => {
  const notYouTubeEl = document.getElementById("not-youtube");
  const youtubeDetectedEl = document.getElementById("youtube-detected");
  const videoTitleEl = document.getElementById("video-title");
  const openDashboardBtn = document.getElementById("open-dashboard-btn");
  const openGeneralDashboardBtn = document.getElementById("open-general-dashboard-btn");

  let activeVideoId = null;
  let activeTabId = null;

  try {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

    if (tab && tab.url && tab.url.includes("youtube.com/watch")) {
      const urlParams = new URL(tab.url).searchParams;
      activeVideoId = urlParams.get("v");
      activeTabId = tab.id;

      notYouTubeEl.classList.add("hidden");
      youtubeDetectedEl.classList.remove("hidden");
      videoTitleEl.textContent = tab.title ? tab.title.replace(" - YouTube", "") : "Vídeo do YouTube";
    } else {
      notYouTubeEl.classList.remove("hidden");
      youtubeDetectedEl.classList.add("hidden");
    }
  } catch (err) {
    console.error("Popup tab error:", err);
    notYouTubeEl.classList.remove("hidden");
    youtubeDetectedEl.classList.add("hidden");
  }

  function openDashboard(videoId = null, tabId = null) {
    let url = chrome.runtime.getURL("dashboard/dashboard.html");
    if (videoId) {
      url += `?videoId=${encodeURIComponent(videoId)}`;
      if (tabId) {
        url += `&tabId=${tabId}`;
      }
    }
    chrome.tabs.create({ url });
    window.close();
  }

  if (openDashboardBtn) {
    openDashboardBtn.addEventListener("click", () => {
      openDashboard(activeVideoId, activeTabId);
    });
  }

  if (openGeneralDashboardBtn) {
    openGeneralDashboardBtn.addEventListener("click", () => {
      openDashboard();
    });
  }
});
