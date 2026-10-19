// Background service worker for YouTube Comments Extractor (Manifest V3)
importScripts("../lib/db.js");

const bgDB = new CommentsDB();

chrome.runtime.onInstalled.addListener((details) => {
  console.log("[YT Extractor Background] Extension installed/updated:", details.reason);
});

// Route and relay messages across contexts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "openDashboard") {
    let url = chrome.runtime.getURL("dashboard/dashboard.html");
    if (message.videoId) {
      url += `?videoId=${encodeURIComponent(message.videoId)}`;
      if (message.tabId) url += `&tabId=${message.tabId}`;
    }
    chrome.tabs.create({ url });
    sendResponse({ success: true });
    return true;
  }

  // Forward comments batch to any open dashboard tabs AND persist to IndexedDB
  if (message.action === "commentsBatch") {
    const { videoId, videoInfo, comments } = message;

    // Persist to IndexedDB directly from background worker (guarantees data survival)
    (async () => {
      try {
        if (videoInfo) {
          await bgDB.upsertVideo(videoInfo);
        }
        if (comments && comments.length > 0) {
          await bgDB.upsertCommentsBatch(videoId, comments);
        }
      } catch (err) {
        console.warn("[YT Extractor Background] DB save error:", err);
      }
    })();

    // Broadcast message to dashboard if open
    chrome.runtime.sendMessage(message).catch(() => {});
    sendResponse({ received: true });
    return true;
  }

  return true;
});
