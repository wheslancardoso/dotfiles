# Contexto e Estado Atual: Otimizações do Antigravity (MCP + Tokens + Arch Linux)

## 1. O que foi feito e validado

### A. Servidores MCP Configurados (~/.gemini/config/mcp_config.json)
1. **`context-mode`**: Execução de scripts e builds em sandbox local com SQLite FTS5, limitando logs a resumos de 40 linhas (`MAX_LOG_LINES: "40"`), poupando até 98% de tokens de terminal.
2. **`repomix`**: Servidor oficial (`npx -y repomix --mcp`) para compressão AST de código local com Tree-sitter, gerando esqueletos de tipos e métodos sem precisar ler arquivos completos.
3. **`context7`**: Pacote oficial `@upstash/context7-mcp` para consulta RAG de documentação de bibliotecas externas sob demanda.
4. **`fast-playwright`**: Pacote `@tontoko/fast-playwright-mcp` configurado com `NO_IMAGES: true`, `INCLUDE_SNAPSHOT: true` e `INCLUDE_CONSOLE: true` para validação rápida de telas e rotas (Angular/React/Next.js).
5. **`github`**: `@modelcontextprotocol/server-github` com isolamento de tarefas por branch e operações diretas via API.
6. **`memory`**: `@modelcontextprotocol/server-memory` para retenção persistente de decisões de arquitetura e relações em formato de grafo JSON.

### B. Regras Globais Ativas (~/.gemini/config/rules/mcp_policy.md)
* Modo **Strict Engineering** (sem conversação prolixa, foco em diffs cirúrgicos).
* **Tool-First & Zero-Deprecation**: Checagem obrigatória de manifestos de versão (`pom.xml`, `package.json`, `pubspec.yaml`) e consulta à documentação oficial/`context7` antes de propor código.
* **Token Hygiene & AST**: Proibição de leituras massivas de arquivos com exigência de `repomix` comprimido.
* **Virtualização de Terminal**: Limitação de logs e stack traces via `context-mode`.
* **Retenção de Arquitetura**: Uso do `memory` para evitar perguntas repetitivas e perda de contexto.
* **Inversão de Controle**: Resolução de ambiguidades arquiteturais antes da geração de código.
* Pilha atendida: Java / Spring Boot, TypeScript, Angular, React, Next.js e Flutter.

### C. Templates e Bloqueios Globais
* `~/.gemini/config/repomix.config.json`: configurações de compressão de repositório.
* `~/.gemini/config/.antigravityignore`: bloqueio de pastas pesadas (`target/`, `node_modules/`, `.dart_tool/`, `build/`, `.gradle/`, logs e caches).

### D. Integração com Chezmoi, Arch Linux e Windows Nativo
* Arquivos salvos em `~/dotfiles/home/dot_gemini/config/`.
* Script de instalação e teste local (WSL/Linux): `~/dotfiles/scripts/setup-antigravity.sh`.
  - Resolve automaticamente o caminho nativo do Linux via Mise shims (`$HOME/.local/share/mise/shims/npx`), evitando conflito com o `npx` do Windows montado em `/mnt/c/` que causava erro de interpretador (`bad interpreter: /bin/sh\r`).
* Script de sincronização com o Windows (Host OS): `~/dotfiles/scripts/sync-antigravity-to-windows.sh`.
  - Injeta MCPs com comando nativo `npx.cmd`.
  - Preserva extensões existentes do Windows (`notebooks`, `visualization`, `data-agent-kit`).
  - Sincroniza regras (`mcp_policy.md`), `.antigravityignore` e `repomix.config.json` para `C:\Users\wheslan.quintanilha\.gemini\config\`.
* Proteção de segredo: no repositório remoto git usa `${GITHUB_PERSONAL_ACCESS_TOKEN}`; localmente na máquina o token real `ghp_...` é preservado.

---

## 2. Como continuar na nova conversa no ~/dotfiles
Ao abrir a nova conversa com o workspace em `~/dotfiles`, você pode simplesmente digitar:
> "Leia o arquivo docs/ANTIGRAVITY_SETUP_CONTEXT.md e continue o fluxo a partir dele."
