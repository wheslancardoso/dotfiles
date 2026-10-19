# 📺 YouTube Comments Extractor (Versão Soberana 1.1.0)

Extensão Chromium modernizada para extração contínua e imune a perda de foco de comentários do YouTube, com persistência em IndexedDB e exportação otimizada para Inteligência Artificial (LLMs).

---

## ⚡ Como Carregar no Navegador (Chrome / Brave / Edge)

1. Abra o navegador e acerte a URL: `chrome://extensions/`
2. No canto superior direito, ative o interruptor **Modo do desenvolvedor** (Developer mode).
3. Se a extensão antiga já estiver instalada:
   - Clique em **Remover** na versão antiga, ou clique no ícone de **Recarregar (🔄)** apontando para esta pasta.
4. Clique em **Carregar sem compactação** (Load unpacked).
5. Selecione a pasta:
   ```
   /home/lanwsl/dotfiles/youtube_comments_extractor/1.0.1_0
   ```

---

## 🚀 Como Usar

1. Abra qualquer vídeo no YouTube (`youtube.com/watch?v=...`).
2. Clique no ícone da extensão na barra de ferramentas e clique em:
   **🚀 Abrir Painel em Nova Aba**
3. O **Painel Soberano** abrirá em uma aba dedicada (`dashboard.html`):
   - **Independência Total de Foco:** Você pode alternar janelas, abrir o terminal, jogar, mexer em outros monitores. A aba dedicada e o script continuam rodando sem fechar nem resetar.
   - **▶️ Iniciar / Retomar Extração:** Rola e captura os comentários em streaming contínuo.
   - **⏸️ Pausar:** Interrompe a rolagem a qualquer momento sem perder um único comentário gravado.
   - **⏹️ Finalizar:** Consolida os dados e encerra o ciclo.
   - **Zero Duplicatas:** Identificadores canônicos do YouTube (`?lc=...`) e chave única no IndexedDB garantem que nenhum comentário ou resposta seja duplicado.

---

## 🤖 Formatos de Exportação para IA

| Formato | Finalidade |
| :--- | :--- |
| **🤖 Markdown p/ IA (`LLM_CONTEXT.md`)** | Árvore conversacional hierárquica (`> ↳ @autor`), metadados em frontmatter YAML e resumo dos comentários com maior engajamento. Ideal para Claude, Gemini, ChatGPT e NotebookLM. |
| **📋 Copiar Contexto IA** | Copia instantaneamente o Markdown estruturado para a área de transferência com 1 clique. |
| **📑 JSONL (`dataset.jsonl`)** | 1 JSON válido por linha. Padrão ouro para RAG, embeddings e scripts Python de processamento de linguagem natural. |
| **🌳 JSON Completo** | Árvore aninhada de comentários com todas as respostas e dados analíticos. |
| **📊 CSV Enriquecido** | Planilha com colunas de relacionamento (`Thread Root ID`, `Parent ID`, `Likes`, etc). |
