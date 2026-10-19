/**
 * YouTube Comments Extractor - AI & LLM-Optimized Export Engine
 * Generates:
 * 1. Markdown com Árvore Hierárquica de Diálogo e Metadados YAML (LLM_CONTEXT.md)
 * 2. JSON Lines Dataset (JSONL) para Fine-tuning / RAG
 * 3. JSON Hierárquico Completo
 * 4. CSV Enriquecido com IDs de Thread
 */

const Exporter = {
  // Helper to trigger browser downloads
  downloadFile(content, filename, mimeType) {
    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  },

  safeFilename(title, ext) {
    const safe = (title || "youtube_video")
      .replace(/[^a-zA-Z0-9_\-\u00C0-\u017F ]/g, "")
      .trim()
      .replace(/\s+/g, "_")
      .substring(0, 60);
    const date = new Date().toISOString().split("T")[0];
    return `youtube_comments_${safe}_${date}.${ext}`;
  },

  /**
   * Gera Markdown Estruturado de Alta Reterção para LLMs (Gemini, Claude, GPT, NotebookLM)
   */
  generateLLMContextMarkdown(videoInfo, hierarchicalData) {
    const { roots, totalComments, totalRoots, totalReplies } = hierarchicalData;

    // Calculate aggregated metrics
    let totalLikes = 0;
    const authorStats = new Map();

    for (const root of roots) {
      totalLikes += root.likeCount || 0;
      const author = root.author?.name || "Desconhecido";
      authorStats.set(author, (authorStats.get(author) || 0) + 1);

      if (root.replies) {
        for (const reply of root.replies) {
          totalLikes += reply.likeCount || 0;
          const repAuthor = reply.author?.name || "Desconhecido";
          authorStats.set(repAuthor, (authorStats.get(repAuthor) || 0) + 1);
        }
      }
    }

    // Top commenters
    const topCommenters = Array.from(authorStats.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([name, count]) => `${name} (${count} participações)`);

    // Top 10 most liked comments
    const allFlat = [];
    for (const root of roots) {
      allFlat.push(root);
      if (root.replies) allFlat.push(...root.replies);
    }
    const topLiked = [...allFlat]
      .sort((a, b) => (b.likeCount || 0) - (a.likeCount || 0))
      .slice(0, 10);

    // Build Frontmatter
    let md = `---
title: ${JSON.stringify(videoInfo.title || "Sem título")}
channel: ${JSON.stringify(videoInfo.channel || "Desconhecido")}
video_id: ${JSON.stringify(videoInfo.videoId || "")}
url: ${JSON.stringify(videoInfo.url || "")}
extracted_at: ${JSON.stringify(videoInfo.lastUpdated || new Date().toISOString())}
total_comments: ${totalComments}
root_comments: ${totalRoots}
total_replies: ${totalReplies}
total_likes_sum: ${totalLikes}
top_active_users: ${JSON.stringify(topCommenters)}
---

# 📺 ${videoInfo.title || "Vídeo do YouTube"}
- **Canal:** [${videoInfo.channel || "Canal"}](${videoInfo.url || "#"})
- **Total de Comentários Extraídos:** ${totalComments} (${totalRoots} principais, ${totalReplies} respostas)
- **Soma Geral de Curtidas:** ${totalLikes.toLocaleString("pt-BR")}
- **Data da Extração:** ${new Date().toLocaleString("pt-BR")}

---

## 🌟 Top 10 Comentários com Maior Engajamento
`;

    topLiked.forEach((c, idx) => {
      const typeLabel = c.isReply ? "↳ Resposta" : "Comentário Raiz";
      md += `\n> **#${idx + 1} [${c.likeCount || 0} 👍 | ${typeLabel}] por @${c.author?.name || "Anônimo"}** (${c.publishedTime || "N/A"})\n`;
      md += `> ${c.content?.text ? c.content.text.replace(/\n/g, "\n> ") : "(Sem texto)"}\n`;
    });

    md += `\n---\n\n## 💬 Fios de Conversação e Discussões Detalhadas\n`;

    // Render discussion threads
    roots.forEach((root, idx) => {
      const rootLikes = root.likeCount ? ` · 👍 ${root.likeCount.toLocaleString()}` : "";
      const rootTime = root.publishedTime ? ` · ${root.publishedTime}` : "";
      const pinned = root.isPinned ? " 📌 [FIXADO]" : "";
      const heart = root.hasCreatorHeart ? " ❤️ [CORAÇÃO DO CRIADOR]" : "";
      const owner = root.author?.isOwner ? " 👑 [CRIADOR]" : "";
      const member = root.author?.isMember ? " ⭐ [MEMBRO]" : "";

      md += `\n### 🧵 Thread #${idx + 1}: @${root.author?.name || "Anônimo"}${pinned}${heart}${owner}${member} (${rootTime}${rootLikes})\n\n`;
      md += `${root.content?.text || "(Sem texto)"}\n`;

      if (root.replies && root.replies.length > 0) {
        md += `\n**Respostas (${root.replies.length}):**\n\n`;
        root.replies.forEach((rep) => {
          const repLikes = rep.likeCount ? ` · 👍 ${rep.likeCount}` : "";
          const repTime = rep.publishedTime ? ` · ${rep.publishedTime}` : "";
          const repHeart = rep.hasCreatorHeart ? " ❤️" : "";
          const repOwner = rep.author?.isOwner ? " 👑" : "";

          md += `> ↳ **@${rep.author?.name || "Anônimo"}**${repOwner}${repHeart} (${repTime}${repLikes}):\n`;
          const repText = (rep.content?.text || "").replace(/\n/g, "\n> ");
          md += `> ${repText}\n>\n`;
        });
      }
      md += `\n---\n`;
    });

    return md;
  },

  /**
   * Gera formato JSON Lines (1 JSON por linha) pronto para RAG e processamento estruturado de IA
   */
  generateJSONL(videoInfo, hierarchicalData) {
    const { roots } = hierarchicalData;
    const lines = [];

    roots.forEach((root, rootIndex) => {
      const rootCleanId = root.rawId || root.id;

      lines.push(
        JSON.stringify({
          record_type: "comment",
          video_id: videoInfo.videoId,
          video_title: videoInfo.title,
          comment_id: rootCleanId,
          parent_id: null,
          thread_root_id: rootCleanId,
          is_reply: false,
          author: root.author?.name || "Unknown",
          author_channel_url: root.author?.channelUrl || "",
          is_owner: !!root.author?.isOwner,
          is_member: !!root.author?.isMember,
          is_pinned: !!root.isPinned,
          has_creator_heart: !!root.hasCreatorHeart,
          published_time: root.publishedTime || "",
          likes: root.likeCount || 0,
          replies_count: root.replies ? root.replies.length : 0,
          text: root.content?.text || "",
        })
      );

      if (root.replies && root.replies.length > 0) {
        root.replies.forEach((rep) => {
          const repCleanId = rep.rawId || rep.id;
          lines.push(
            JSON.stringify({
              record_type: "reply",
              video_id: videoInfo.videoId,
              video_title: videoInfo.title,
              comment_id: repCleanId,
              parent_id: rootCleanId,
              thread_root_id: rootCleanId,
              is_reply: true,
              author: rep.author?.name || "Unknown",
              author_channel_url: rep.author?.channelUrl || "",
              is_owner: !!rep.author?.isOwner,
              is_member: !!rep.author?.isMember,
              is_pinned: false,
              has_creator_heart: !!rep.hasCreatorHeart,
              published_time: rep.publishedTime || "",
              likes: rep.likeCount || 0,
              replies_count: 0,
              text: rep.content?.text || "",
            })
          );
        });
      }
    });

    return lines.join("\n");
  },

  /**
   * Gera JSON Hierárquico Formatado
   */
  generateHierarchicalJSON(videoInfo, hierarchicalData) {
    const output = {
      videoInfo: {
        ...videoInfo,
        exportedAt: new Date().toISOString(),
      },
      stats: {
        totalComments: hierarchicalData.totalComments,
        totalRoots: hierarchicalData.totalRoots,
        totalReplies: hierarchicalData.totalReplies,
      },
      comments: hierarchicalData.roots,
    };
    return JSON.stringify(output, null, 2);
  },

  /**
   * Gera CSV Enriquecido com relações hierárquicas preservadas
   */
  generateEnhancedCSV(videoInfo, hierarchicalData) {
    const escapeCsv = (str) => {
      if (str === null || str === undefined) return "";
      str = String(str);
      if (str.includes('"') || str.includes(",") || str.includes("\n") || str.includes("\r")) {
        return '"' + str.replace(/"/g, '""') + '"';
      }
      return str;
    };

    const headers = [
      "Comment ID",
      "Type",
      "Parent ID",
      "Thread Root ID",
      "Author",
      "Text",
      "Likes",
      "Replies Count",
      "Published Time",
      "Is Pinned",
      "Has Creator Heart",
      "Is Video Owner",
      "Video ID",
      "Video Title",
    ];

    const rows = [headers.join(",")];

    hierarchicalData.roots.forEach((root) => {
      const rootId = root.rawId || root.id;
      rows.push(
        [
          escapeCsv(rootId),
          "Root",
          "",
          escapeCsv(rootId),
          escapeCsv(root.author?.name),
          escapeCsv(root.content?.text),
          root.likeCount || 0,
          root.replies ? root.replies.length : 0,
          escapeCsv(root.publishedTime),
          root.isPinned ? "Yes" : "No",
          root.hasCreatorHeart ? "Yes" : "No",
          root.author?.isOwner ? "Yes" : "No",
          escapeCsv(videoInfo.videoId),
          escapeCsv(videoInfo.title),
        ].join(",")
      );

      if (root.replies) {
        root.replies.forEach((rep) => {
          const repId = rep.rawId || rep.id;
          rows.push(
            [
              escapeCsv(repId),
              "Reply",
              escapeCsv(rootId),
              escapeCsv(rootId),
              escapeCsv(rep.author?.name),
              escapeCsv(rep.content?.text),
              rep.likeCount || 0,
              0,
              escapeCsv(rep.publishedTime),
              "No",
              rep.hasCreatorHeart ? "Yes" : "No",
              rep.author?.isOwner ? "Yes" : "No",
              escapeCsv(videoInfo.videoId),
              escapeCsv(videoInfo.title),
            ].join(",")
          );
        });
      }
    });

    return rows.join("\n");
  },
};

window.Exporter = Exporter;
