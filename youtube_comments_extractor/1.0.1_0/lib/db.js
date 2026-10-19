/**
 * YouTube Comments Extractor - IndexedDB Persistence Layer
 * Provides robust storage, incremental saving, deduplication and retrieval
 */

const DB_NAME = "YouTubeCommentsExtractorDB";
const DB_VERSION = 1;

class CommentsDB {
  constructor() {
    this.db = null;
    this.initPromise = null;
  }

  async init() {
    if (this.db) return this.db;
    if (this.initPromise) return this.initPromise;

    this.initPromise = new Promise((resolve, reject) => {
      const request = indexedDB.open(DB_NAME, DB_VERSION);

      request.onupgradeneeded = (event) => {
        const db = event.target.result;

        // Videos Store
        if (!db.objectStoreNames.contains("videos")) {
          const videoStore = db.createObjectStore("videos", { keyPath: "videoId" });
          videoStore.createIndex("lastUpdated", "lastUpdated", { unique: false });
        }

        // Comments Store
        if (!db.objectStoreNames.contains("comments")) {
          const commentStore = db.createObjectStore("comments", { keyPath: "id" });
          commentStore.createIndex("videoId", "videoId", { unique: false });
          commentStore.createIndex("parentId", "parentId", { unique: false });
          commentStore.createIndex("isReply", "isReply", { unique: false });
          commentStore.createIndex("likeCount", "likeCount", { unique: false });
          commentStore.createIndex("video_reply", ["videoId", "isReply"], { unique: false });
        }
      };

      request.onsuccess = (event) => {
        this.db = event.target.result;
        resolve(this.db);
      };

      request.onerror = (event) => {
        console.error("[CommentsDB] Database error:", event.target.error);
        reject(event.target.error);
      };
    });

    return this.initPromise;
  }

  async getTransaction(storeNames, mode = "readonly") {
    const db = await this.init();
    return db.transaction(storeNames, mode);
  }

  // --- Videos Management ---

  async upsertVideo(videoData) {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["videos"], "readwrite");
      const store = tx.objectStore("videos");

      const getReq = store.get(videoData.videoId);
      getReq.onsuccess = () => {
        const existing = getReq.result || {};
        const updated = {
          ...existing,
          ...videoData,
          lastUpdated: new Date().toISOString(),
        };
        const putReq = store.put(updated);
        putReq.onsuccess = () => resolve(updated);
        putReq.onerror = () => reject(putReq.error);
      };
      getReq.onerror = () => reject(getReq.error);
    });
  }

  async getVideo(videoId) {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["videos"], "readonly");
      const store = tx.objectStore("videos");
      const req = store.get(videoId);
      req.onsuccess = () => resolve(req.result || null);
      req.onerror = () => reject(req.error);
    });
  }

  async getAllVideos() {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["videos"], "readonly");
      const store = tx.objectStore("videos");
      const req = store.getAll();
      req.onsuccess = () => {
        const list = req.result || [];
        list.sort((a, b) => new Date(b.lastUpdated || 0) - new Date(a.lastUpdated || 0));
        resolve(list);
      };
      req.onerror = () => reject(req.error);
    });
  }

  async deleteVideo(videoId) {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["videos", "comments"], "readwrite");
      const videoStore = tx.objectStore("videos");
      const commentStore = tx.objectStore("comments");
      const index = commentStore.index("videoId");

      videoStore.delete(videoId);

      const request = index.openKeyCursor(IDBKeyRange.only(videoId));
      request.onsuccess = (event) => {
        const cursor = event.target.result;
        if (cursor) {
          commentStore.delete(cursor.primaryKey);
          cursor.continue();
        }
      };

      tx.oncomplete = () => resolve(true);
      tx.onerror = () => reject(tx.error);
    });
  }

  // --- Comments Management (Batch & Incremental Upsert) ---

  /**
   * Upserts a batch of comments. Ensures no duplicates by composite or unique ID.
   */
  async upsertCommentsBatch(videoId, commentsList) {
    if (!commentsList || commentsList.length === 0) {
      return { added: 0, updated: 0, totalNow: await this.getCommentCount(videoId) };
    }

    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["comments", "videos"], "readwrite");
      const commentStore = tx.objectStore("comments");
      const videoStore = tx.objectStore("videos");

      let added = 0;
      let updated = 0;

      for (const comment of commentsList) {
        // Enforce consistent unique ID per video
        const cleanId = comment.rawId || comment.id;
        const recordId = `${videoId}_${cleanId}`;

        const record = {
          ...comment,
          id: recordId,
          rawId: cleanId,
          videoId: videoId,
          savedAt: comment.savedAt || new Date().toISOString(),
        };

        commentStore.put(record);
      }

      tx.oncomplete = async () => {
        // Update counters on video record
        const counts = await this.getCommentCount(videoId);
        const getVid = videoStore.get(videoId);
        getVid.onsuccess = () => {
          if (getVid.result) {
            const vid = getVid.result;
            vid.extractedRootCount = counts.roots;
            vid.extractedRepliesCount = counts.replies;
            vid.extractedTotal = counts.total;
            vid.lastUpdated = new Date().toISOString();
            // Use separate quick transaction to update counts
            const updateTx = db.transaction(["videos"], "readwrite");
            updateTx.objectStore("videos").put(vid);
          }
        };
        resolve(counts);
      };

      tx.onerror = () => reject(tx.error);
    });
  }

  async getCommentCount(videoId) {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["comments"], "readonly");
      const index = tx.objectStore("comments").index("videoId");
      const req = index.getAll(IDBKeyRange.only(videoId));

      req.onsuccess = () => {
        const comments = req.result || [];
        let roots = 0;
        let replies = 0;
        for (const c of comments) {
          if (c.isReply) replies++;
          else roots++;
        }
        resolve({ total: comments.length, roots, replies });
      };
      req.onerror = () => reject(req.error);
    });
  }

  async getExistingCommentIds(videoId) {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["comments"], "readonly");
      const index = tx.objectStore("comments").index("videoId");
      const req = index.getAll(IDBKeyRange.only(videoId));

      req.onsuccess = () => {
        const idSet = new Set();
        for (const c of (req.result || [])) {
          if (c.rawId) idSet.add(c.rawId);
          idSet.add(c.id);
        }
        resolve(idSet);
      };
      req.onerror = () => reject(req.error);
    });
  }

  /**
   * Returns all comments for a video structured as a hierarchical tree (root comments with nested replies)
   */
  async getHierarchicalComments(videoId) {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["comments"], "readonly");
      const index = tx.objectStore("comments").index("videoId");
      const req = index.getAll(IDBKeyRange.only(videoId));

      req.onsuccess = () => {
        const rawComments = req.result || [];
        const rootComments = [];
        const repliesByParent = new Map();

        for (const c of rawComments) {
          if (c.isReply && c.parentId) {
            // Strip videoId prefix if present in parentId
            const cleanParent = c.parentId.replace(`${videoId}_`, "");
            if (!repliesByParent.has(cleanParent)) {
              repliesByParent.set(cleanParent, []);
            }
            repliesByParent.get(cleanParent).push(c);
          } else {
            rootComments.push({ ...c, replies: [] });
          }
        }

        // Attach replies to roots
        for (const root of rootComments) {
          const rootCleanId = root.rawId || root.id.replace(`${videoId}_`, "");
          const replies = repliesByParent.get(rootCleanId) || [];
          root.replies = replies;
          root.replyCount = replies.length;
        }

        // Sort roots by order or likes
        resolve({
          roots: rootComments,
          totalComments: rawComments.length,
          totalRoots: rootComments.length,
          totalReplies: rawComments.length - rootComments.length,
        });
      };
      req.onerror = () => reject(req.error);
    });
  }

  async clearAll() {
    const db = await this.init();
    return new Promise((resolve, reject) => {
      const tx = db.transaction(["videos", "comments"], "readwrite");
      tx.objectStore("videos").clear();
      tx.objectStore("comments").clear();
      tx.oncomplete = () => resolve(true);
      tx.onerror = () => reject(tx.error);
    });
  }
}

// Export singleton instance for browser global / service worker context
const globalScope = typeof window !== "undefined" ? window : typeof self !== "undefined" ? self : this;
globalScope.commentsDB = new CommentsDB();
if (typeof self !== "undefined" && typeof self.CommentsDB === "undefined") {
  self.CommentsDB = CommentsDB;
}

