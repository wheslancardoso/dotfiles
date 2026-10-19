// Background service worker for YouTube Comments Extractor (Manifest V3)

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

  // Forward comments batch to any open dashboard tabs
  if (message.action === "commentsBatch") {
    // Broadcast message so dashboard receives it
    chrome.runtime.sendMessage(message).catch(() => {
      // Ignore if no dashboard is currently open to receive
    });
    sendResponse({ received: true });
    return true;
  }

  return true;
});
