# Neovim / LazyVim — Índice Mestre e Guia Rápido (VS Code → Neovim)

> Guia central de consulta para agentes de IA e referência rápida do dia a dia para substituir o VS Code pelo nosso setup Neovim/LazyVim.

---

## 1. Mapa da Documentação

| Arquivo | Quando Consultar | Conteúdo Principal |
| :--- | :--- | :--- |
| [01-core-and-keymaps.md](file:///home/lanwsl/dotfiles/docs/nvim/01-core-and-keymaps.md) | Dúvidas de atalhos gerais, opções do editor, UI, tema ou edição | `init.lua`, `lazy.lua`, `stylua.toml`, `lazyvim.json`, `options.lua`, `keymaps.lua`, `editor.lua` (surround, multi-cursor, blink.cmp, mini.pairs, refactoring, undotree), `ui.lua` (dropbar, which-key, zen-mode, snacks, smear-cursor), `theme.lua` (Catppuccin Mocha) e `treesitter.lua` (parsers + sticky scroll). |
| [02-languages-and-lsp.md](file:///home/lanwsl/dotfiles/docs/nvim/02-languages-and-lsp.md) | Dúvidas de LSP, Mason, Java/Spring, Python, Rust, Web/Angular/Flutter | `mason.nvim` (`ensure_installed`), `nvim-lspconfig` (`angularls`, `html`, `emmet_language_server`), `nvim-jdtls` (Java 17/21, auto-scaffolding, Maven, JUnit), `venv-selector.nvim`, `crates.nvim`, `nvim-colorizer.lua`, `flutter-tools.nvim` e injeções HTML em JS/TS. |
| [03-tools-git-db-rest.md](file:///home/lanwsl/dotfiles/docs/nvim/03-tools-git-db-rest.md) | Banco de dados, Git diff/merge/conflitos ou requisições HTTP | `vim-dadbod` + `vim-dadbod-ui` (`fiscalizacao`), `diffview.nvim`, `gitsigns.nvim`, `git-conflict.nvim`, `kulala.nvim` (`.http`/`.rest`) e inventário de `lazy-lock.json` (79 plugins). |

---

## 2. Equivalência Rápida: VS Code → Nosso Neovim/LazyVim

| Ação no VS Code | No Nosso Neovim | Plugin / Config |
| :--- | :--- | :--- |
| `Ctrl+S` (Salvar) | `<C-s>` (modos `i, x, n, s`) | `keymaps.lua` |
| `Ctrl+W` (Fechar aba) | `<leader>bd` (ou `<leader>qq` para sair de tudo) | `keymaps.lua` |
| Alternar abas | `<S-h>` (anterior) / `<S-l>` (próximo) | `keymaps.lua` |
| Navegar entre painéis | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | `keymaps.lua` |
| Redimensionar painéis | `<C-Up/Down/Left/Right>` | `keymaps.lua` |
| Mover linha cima/baixo | `<A-k>` / `<A-j>` (`n, i, v`) | `keymaps.lua` |
| `Ctrl+D` (Multi-cursor) | `<C-n>` (palavra) / `<C-Down>/<C-Up>` (vertical) | `vim-visual-multi` |
| `Format Selection` | `<leader>cf` em modo visual (`x`) | `keymaps.lua` (`conform` / `=`) |
| `Ctrl+K Ctrl+S` (Buscar atalhos) | `<leader>?` ou `<leader>sk` | `Telescope keymaps` |
| Breadcrumbs no topo | Barra automática no topo do buffer | `dropbar.nvim` |
| Sticky Scroll (classe/função) | Ativo no topo; `[c` pula ao contexto, `<leader>uc` alterna | `nvim-treesitter-context` |
| Zen Mode (Hiperfoco) | `<leader>z` ou `<leader>uz` | `zen-mode.nvim` |
| Histórico local (Timeline) | `<leader>ut` (árvore ramificada persistente) | `undotree` + `undofile` |
| Buscar `TODO` / `FIXME` | `<leader>st` (Telescope), `<leader>xt` (Trouble), `]t`/`[t` | `todo-comments.nvim` |
| Code Actions / Quick Fix | `<leader>ca` (em Java) | `nvim-jdtls` |
| Source Control (Git UI) | `<leader>gg` (LazyGit) | `Snacks.lazygit` |
| Git Diff / Histórico | `<leader>gd` (Diffview), `<leader>gh` (arquivo), `<leader>gH` (branch), `<leader>gq` (fechar) | `diffview.nvim` |
| Resolver Merge Conflicts | `<leader>gml` (listar), `<leader>gmn`/`p` (navegar), `<leader>gmo`/`t`/`b`/`0` (escolher), `<leader>gmd` (3-way) | `git-conflict.nvim` |
| Inline Git Blame | Automático na linha atual (`delay = 300ms`) | `gitsigns.nvim` |
| Database Client (DBeaver/Ext) | `<leader>D` (`:DBUIToggle`) | `vim-dadbod-ui` |
| REST Client (Insomnia/Postman) | `<leader>Rr` (executar), `<leader>Ra` (todos), `<leader>Re` (env) em `.http`/`.rest` | `kulala.nvim` |
| Terminal AI (`agy`) | `<leader>ai` | `Snacks.terminal("agy")` |

---

## 3. Top Fluxos Rápidos do Dia a Dia

### Navegação, Edição & Sessão
- **Restaurar projeto**: `<leader>qs` (diretório atual) ou `<leader>ql` (última sessão) via `persistence.nvim`.
- **Autocompletar (`blink.cmp`)**: `super-tab` com `<C-j>`/`<C-n>` (próximo), `<C-k>`/`<C-p>` (anterior) e `<CR>` apenas quebra linha. Em JS/TS/JSX/TSX, Emmet só aparece dentro de crases (`` `...` ``).
- **Edição cirúrgica**: `nvim-surround` (`ysiw"`, `cs"'`, `ds"`), `mini.splitjoin` (`gS`), `mini.align` (`ga`), `substitute.nvim` (`gs{motion}` sem sujar clipboard; `cx{motion}` para trocar dois blocos de lugar).
- **Refatoração**: `<leader>re` (Extrair Função), `<leader>rv` (Variável), `<leader>ri` (Inline) via `refactoring.nvim`.

### Git & Conflitos
- **Dia a dia**: `<leader>gg` abre o LazyGit; `<leader>gd` abre o `DiffviewOpen`; `<leader>gh` mostra o histórico do arquivo atual.
- **Conflitos de merge**: `<leader>gml` lista no Quickfix → `<leader>gmn`/`<leader>gmp` navega → `<leader>gmo` (ours), `<leader>gmt` (theirs), `<leader>gmb` (both) ou `<leader>gmd` (3-way merge tool).

### Banco de Dados & REST
- **SQL (`vim-dadbod-ui`)**: `<leader>D` → selecionar `fiscalizacao` (`mysql://root:root@127.0.0.1:3306/fiscalizacao`) ou `:DBUIAddConnection` → escrever SQL com autocompletar.
- **HTTP/REST (`kulala.nvim`)**: abrir `.http`/`.rest` → `<leader>Re` (ambiente, padrão `dev`) → `<leader>Rr` (requisição sob o cursor) → `<leader>Rt` (alternar Body/Headers) ou `<leader>Rc` (copiar cURL).

### Linguagens (Java, Python, Rust, Web/Flutter)
- **Java / Spring Boot**: criar `.java` gera `package` + `class`/`interface` automaticamente; `<leader>jo` (organizar imports), `<leader>jg` (gerar getters/construtor/`toString`/`equals`), `<leader>jmr` (Spring Boot run), `<leader>jmt` (Maven test), `<leader>jtc`/`<leader>jtm` (JUnit), `<leader>ju` (atualizar `pom.xml`).
- **Python**: `<leader>cv` (`:VenvSelect`) para selecionar `.venv`/`venv` para o `pyright` (`ruff`, `black`, `debugpy` via Mason).
- **Rust**: `rust-analyzer` via Mason + `crates.nvim` em `Cargo.toml`.
- **Web / Angular / Flutter**: `vtsls`, `angularls`, `tailwindcss-language-server`, `nvim-colorizer` inline; em Dart, `<leader>Fr` (Hot Reload) e `<leader>FR` (Hot Restart).
