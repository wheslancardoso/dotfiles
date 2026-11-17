# Neovim / LazyVim — Core, Opções, Keymaps, Editor, UI, Tema e Treesitter

> Referência técnica em pt-BR para agentes de IA e consulta rápida do usuário na transição do VS Code para o Neovim. Todos os dados abaixo refletem exclusivamente os arquivos de configuração do repositório.

---

## 1. Bootstrap, Gerenciador de Plugins e Formatação Lua

- **Entrada (`init.lua`)**: Carrega `require("config.lazy")`.
- **Gerenciador (`lua/config/lazy.lua`)**:
  - Clona `folke/lazy.nvim` (branch `stable`, `--filter=blob:none`) em `stdpath("data") .. "/lazy/lazy.nvim"` caso não exista.
  - `defaults`: `lazy = false`, `version = false`.
  - `install.colorscheme`: `catppuccin`, `tokyonight`, `habamax`.
  - `checker`: `enabled = true`, `notify = false`.
  - `performance.rtp.disabled_plugins`: `gzip`, `tarPlugin`, `tohtml`, `tutor`, `zipPlugin`.
- **Estilo Lua (`stylua.toml`)**:
  - `indent_type = "Spaces"`, `indent_width = 2`, `column_width = 120`.

---

## 2. Opções Core (`lua/config/options.lua`)

| Opção | Valor | Comportamento |
| :--- | :--- | :--- |
| `vim.g.autoformat` | `true` | Formatação automática ao salvar |
| `vim.opt.clipboard` | `"unnamedplus"` | Sincronização direta com clipboard do sistema (Wayland/X11: `wl-copy` / `xclip`) |
| `vim.opt.relativenumber` / `number` | `true` / `true` | Numeração híbrida (linha atual absoluta, demais relativas) |
| `shiftwidth` / `tabstop` / `softtabstop` | `2` / `2` / `2` | Indentação padrão de 2 espaços |
| `expandtab` / `smartindent` | `true` / `true` | Converte Tab em espaços e indenta automaticamente |
| `wrap` | `false` | Sem quebra visual de linha |
| `termguicolors` | `true` | Cores 24-bit no terminal |
| `cursorline` | `true` | Destaca a linha do cursor |
| `signcolumn` | `"yes"` | Coluna de sinais sempre visível (evita saltos de layout) |
| `scrolloff` / `sidescrolloff` | `8` / `8` | Margem mínima de 8 linhas/colunas ao rolar |
| `undofile` / `undolevels` | `true` / `10000` | Histórico de desfazer persistente entre sessões |
| `ignorecase` / `smartcase` | `true` / `true` | Busca case-insensitive, exceto quando há maiúsculas na query |
| `updatetime` / `timeoutlen` | `200` / `300` | Resposta rápida de eventos e sequências de teclas |

- **Detecção de Filetypes (`vim.filetype.add`)**:
  - `.*/hypr/.*%.conf` e `hyprland%.conf` → `hyprlang`
  - `.*%.kdl` → `kdl`
- **Suporte Neovide (`if vim.g.neovide`)**:
  - `neovide_cursor_vfx_mode = "railgun"`, `neovide_cursor_animation_length = 0.15`, `neovide_cursor_trail_size = 0.8`, `neovide_cursor_vfx_opacity = 200.0`, `neovide_cursor_vfx_particle_speed = 20.0`, `neovide_cursor_vfx_particle_density = 7.0`.

---

## 3. Autocmds (`lua/config/autocmds.lua`)

- Não há autocmds customizados declarados em `lua/config/autocmds.lua`; o arquivo utiliza apenas os autocmds padrão do LazyVim.

---

## 4. LazyVim Extras Habilitados (`lazyvim.json` & `lua/config/lazy.lua`)

Em `lazyvim.json` (version `8`, `install_version: 7`):
- **DAP & Testes**: `dap.core`, `dap.nlua`, `test.core`
- **Editor & UI**: `editor.harpoon2`, `ui.edgy`, `util.dot`
- **Formatação**: `formatting.prettier`
- **Linguagens**: `lang.docker`, `lang.git`, `lang.go`, `lang.java`, `lang.json`, `lang.markdown`, `lang.python`, `lang.rust`, `lang.tailwind`, `lang.typescript`, `lang.yaml`
- **Adicional em `lua/config/lazy.lua`**: `lazyvim.plugins.extras.lang.angular` também é importado na spec do `lazy.setup`.

---

## 5. Keymaps Customizados (`lua/config/keymaps.lua`)

| Modo | Atalho | Ação | Equivalente / Fluxo VS Code |
| :--- | :--- | :--- | :--- |
| `i, x, n, s` | `<C-s>` | Salvar arquivo (`<cmd>w<cr><esc>`) | `Ctrl+S` |
| `n` | `<leader>qq` | Sair de tudo (`<cmd>qa<cr>`) | Fechar janela |
| `i, n` | `<esc>` | Limpar realce de busca (`noh`) e voltar ao Normal | `Esc` limpa seleção/busca |
| `n` | `<C-h/j/k/l>` | Navegar entre splits (esquerda/baixo/cima/direita) | Navegar entre grupos de editor |
| `n` | `<C-Up/Down/Left/Right>` | Redimensionar split (`±2` linhas/colunas) | Arrastar divisória |
| `n` | `<S-h>` / `<S-l>` | Buffer anterior / próximo buffer | Alternar abas |
| `n` | `<leader>bd` | Fechar buffer atual | `Ctrl+W` |
| `n, i, v` | `<A-j>` / `<A-k>` | Mover linha ou seleção para baixo / cima | `Alt+Down` / `Alt+Up` |
| `n` | `<leader>gg` | Abrir LazyGit (`Snacks.lazygit()` ou `:LazyGit`) | Painel Source Control |
| `n` | `<leader>ai` | Toggle terminal `agy` no `cwd` (`Snacks.terminal`) | Terminal integrado CLI AI |
| `n` | `<leader>?` / `<leader>sk` | Buscar qualquer atalho (`Telescope keymaps`) | `Ctrl+K Ctrl+S` |
| `n` | `<leader>vk` | Abrir `$HOME/dotfiles/docs/GUIA_ATALHOS_E_KEYBINDS_MESTRE.md` em modo `view` | Cheatsheet rápido |
| `n` | `<leader>vg` | Iniciar `:VimBeGood` | Treino de memória muscular |
| `x` | `<leader>cf` | Formatação cirúrgica da seleção visual: usa `=` (Treesitter/Vim) em `html`/`htmlangular`/`xml`, e `conform.format` com `range` nas demais linguagens | `Format Selection` |

---

## 6. Plugins de Editor (`lua/plugins/editor.lua`)

| Plugin | Função Principal | Atalhos / Configuração |
| :--- | :--- | :--- |
| `windwp/nvim-ts-autotag` | Fecha e renomeia tags automaticamente | Ativo em `html`, `htmlangular`, `javascript`, `typescript`, `javascriptreact`, `typescriptreact`, `vue`, `svelte` (`enable_close`, `enable_rename`, `enable_close_on_slash`) |
| `kylechui/nvim-surround` | Manipular aspas, parênteses e tags | `ysiw"` (envolver palavra), `cs"'` (trocar), `ds"` (remover), `ysit<p>` (envolver com tag) |
| `nvim-mini/mini.splitjoin` | Alternar bloco entre 1 linha e multi-linha | `gS` |
| `nvim-mini/mini.align` | Alinhar código por caractere (`=`, `:`, `,`, etc.) | `ga` |
| `ThePrimeagen/refactoring.nvim` | Extração e inline de código | `v`: `<leader>re` (Extrair Função), `<leader>rf` (Para Arquivo), `<leader>rv` (Variável); `n,v`: `<leader>ri` (Inline Variável); `n`: `<leader>rb` (Extrair Bloco) |
| `folke/todo-comments.nvim` | Realce e busca de `TODO`, `FIXME`, `BUG` | `]t` / `[t` (próximo/anterior), `<leader>xt` (Trouble), `<leader>st` (Telescope) |
| `folke/persistence.nvim` | Salvar/restaurar sessões por diretório | `<leader>qs` (restaurar projeto), `<leader>ql` (última sessão), `<leader>qd` (parar salvamento) |
| `ThePrimeagen/vim-be-good` | Jogo de treino Vim | `:VimBeGood` (ou `<leader>vg`) |
| `mbbill/undotree` | Histórico ramificado de edições | `<leader>ut` (`UndotreeToggle`, foco automático, `WindowLayout = 2`) |
| `mg979/vim-visual-multi` | Multi-cursor estilo VS Code | `<C-n>` (`Find Under` / `Find Subword Under`), `<C-Down>/<C-Up>` (cursor vertical) |
| `gbprod/substitute.nvim` | Substituição sem poluir registradores + troca de posição | `gs{motion}`, `gss` (linha), `gs` (`x`); Exchange: `cx{motion}`, `cxx` (linha), `cxc` (cancelar), `X` (`x`) |
| `saghen/blink.cmp` | Autocompletar `super-tab` | `<C-j>` / `<NL>` / `<C-n>` (próximo), `<C-k>` / `<C-p>` (anterior), `<CR>` apenas quebra linha (`fallback`). **Filtro Emmet**: em JS/TS/JSX/TSX, `emmet_ls` / `emmet_language_server` só aparece dentro de `template_string` (crases) |
| `nvim-mini/mini.pairs` | Auto-fechamento de `""`, `''`, `[]`, `{}`, `()` | `skip_ts = {}`; trata aspas escapadas (`\"`) para inserir literal sem pular fechamento e apagar sem remover a aspa final da string |

---

## 7. Plugins de UI (`lua/plugins/ui.lua`)

- **`Bekaboo/dropbar.nvim`**: Breadcrumbs clicáveis no topo do buffer (`buftype == ""` e `filetype ~= ""`).
- **`folke/which-key.nvim`**: Grupos configurados no menu `<leader>`:
  - `<leader>D` Database (Dadbod), `<leader>R` REST API (Kulala), `<leader>r` Refactor, `<leader>F` Flutter Mobile, `<leader>a` AI Agent (Antigravity), `<leader>u` UI / Visual Toggles, `<leader>gm` Git Conflicts / Merge, `<leader>j` Java (JDTLS), `<leader>jg` Generate, `<leader>jm` Maven / Spring Boot, `<leader>jr` Refactor / Extração, `<leader>jt` Test (JUnit).
- **`folke/zen-mode.nvim`**: Hiperfoco (`<leader>z` ou `<leader>uz`), largura `120`, `backdrop = 0.95`, oculta números, `signcolumn`, `laststatus` e `gitsigns`.
- **`folke/noice.nvim`**: Filtra (`skip = true`) notificações de progresso LSP do `jdtls` ou com título contendo `"Validating"`.
- **`HiPhish/rainbow-delimiters.nvim`**: Colorização hierárquica de `()`, `{}`, `[]` (`RainbowDelimiterRed/Yellow/Blue/Orange/Green/Violet/Cyan`).
- **`folke/snacks.nvim`**:
  - `scroll`: rolagem suave animada (`step = 15`, `total = 200`, `linear`).
  - `dim`: escurecimento de código fora de foco.
  - `indent`: guias verticais `│`, `scope` com `underline = true` no início do escopo ativo e `chunk` com cantos `╭`/`╰` e seta `>`.
- **`sphamba/smear-cursor.nvim`**: Rastro de fogo moderado e constante (`cursor_color = "#ff4000"`, `particles_enabled = true`, `min_distance_emit_particles = 0`, `particles_over_text = false`, `particle_max_num = 80`, `time_interval = 17`, `particle_gravity = -50`) — emite faíscas continuamente ao digitar/mover, sem travar o terminal e sem cobrir o texto.
- **`rachartier/tiny-glimmer.nvim`**: Animações em tons de fogo (`#ff4000`–`#ffaa00`) para `yank` (`y`), `paste` (`p`/`P`), `undo` (`u`), `redo` (`<C-r>`) e `search` (`n`/`N`).
- **`axsaucedo/neovim-power-mode`**: Combo estilo Guitar Hero no canto superior direito (`timeout = 8000` ms / 8s, `ON FIRE!`, `GODLIKE!`, etc.), partículas (`rightburst`, `avoid_cursor = true`), fogo no Backspace, **Fire Wall** (`fire_wall.enabled = true`) no rodapé e **troca completa de tema por streak** (alterna entre `tokyonight-night`, `tokyonight-storm`, `catppuccin-frappe` e `catppuccin-mocha` com fundo vulcânico/carmesim nos níveis 10+/25+/50+/100+/200+; mantém o tema ativo mesmo ao apertar `<Esc>` enquanto você navega/edita, restaurando o `catppuccin-mocha` após 8s de inatividade; `shake.mode = "none"`).
- **`eandrju/cellular-automaton.nvim`**: Toggle de animações no buffer: `<leader>ur` (`make_it_rain`), `<leader>ug` (`game_of_life`), `<leader>us` (`scramble`).
- **`DanilaMihailov/beacon.nvim`**: Flash visual em saltos ≥ 10 linhas ou troca de janela (`size = 35`, `focus_gained = true`).

### Efeitos Visuais & Modo Fogo / Heaven Neon (Guitar Hero + Como Reverter)

- **Kitty (`home/dot_config/kitty/kitty.conf`)**: `allow_remote_control yes`, `cursor_trail 3`, `cursor_trail_decay 0.1 0.5`, `cursor_trail_start_threshold 1`, `cursor_trail_color #ff4000` (rastro GPU em chamas + sincronização ao vivo das cores do Kitty via `kitty @ set-colors` a cada nível de streak).
- **Shockwave no Level-Up**: ao cruzar cada degrau de streak, dispara `beacon.highlight_cursor()` + flash de 240ms na linha inteira (`PowerModeShockwave`).
- **Flash ao sair do Insert (`lua/config/autocmds.lua`)**: ao pressionar `<Esc>` (`InsertLeave`) em buffers normais, pisca `🔥` (no preset `fire`) ou `✨` (no preset `heaven`) no cursor por 220ms via `extmark` (`hl_mode = "replace"`, sem alterar o texto).
- **Alternar Preset (`<leader>uP` ou `:PowerPreset [fire|heaven]`)**: troca instantaneamente entre o modo **`fire`** (padrão) e **`heaven`** (neon/celestial), atualizando também a cor do `smear-cursor` e o emoji do `InsertLeave`.
- **Progressão de Tema por Streak (`axsaucedo/neovim-power-mode` em `ui.lua`)**:

| Nível / Streak | Preset `fire` | Preset `heaven` |
|---|---|---|
| **0–9 (Normal)** | `catppuccin-mocha` | `catppuccin-mocha` |
| **10+ (Nível 1)** | `tokyonight-night` — Overdrive (`#39ff14`) | `tokyonight-night` — Neon Pulse (`#00f5ff`) |
| **25+ (Nível 2)** | `tokyonight-storm` — Super Saiyan (`#ffd700`) | `tokyonight-moon` — Hyperion (`#7aa2f7`) |
| **50+ (Nível 3)** | `catppuccin-frappe` — On Fire (`#ff8800`) | `catppuccin-macchiato` — Ultraviolet (`#c792ea`) |
| **80+ (Nível 4)** | `catppuccin-mocha` — Inferno (`#ff4000` / `#290b05`) | `catppuccin-mocha` — Neon Heaven (`#ff2cf1` / `#210926`) |
| **120+ (Nível 5)** | `catppuccin-mocha` — Godlike (`#ff0055` / `#260513`) | `catppuccin-mocha` — Celestial (`#fff3b0` / `#1e1d30`) |
| **150+ → 300+ (Níveis 6–10)** | **Ascensão ao `heaven`**: rotaciona os 5 níveis Neon/Celestial (`150`, `180`, `210`, `250`, `300`), transforma a `fire_wall` em **Aurora Boreal** (`#fff3b0` → `#00f5ff` → `#7aa2f7` → `#c792ea`), troca partículas para `stars` e muda cursor/flash para `#00f5ff` (`gravity = 5`) + `✨` | — |

- Ao subir de nível (e ao voltar para o `catppuccin-mocha`), o editor executa uma **transição animada RGB de 10 frames (~220ms)** com pico de brilho e assentamento suave de cor, além de notificação (`Power Mode`) e colorização do **Neo-tree**, `LineNr`, `StatusLine` e `Visual`. No nível máximo **Celestial** (`300+` no `fire` ou `120+` no `heaven`), as bordas e a `StatusLine` **pulsam continuamente** entre dourado (`#fff3b0`) e ciano neon (`#00f5ff`).

- **Como reverter apenas a troca de tema** (mantendo `smear-cursor`, `tiny-glimmer` e `neovim-power-mode` com combo + Fire Wall): em `lua/plugins/ui.lua`, remova o bloco `config = function(_, opts) ... end` dentro da entrada de `axsaucedo/neovim-power-mode`, deixando somente `opts = { ... }`.

---

## 8. Tema (`lua/plugins/theme.lua`)

- **Colorscheme**: `catppuccin-mocha` (`catppuccin/nvim`, `flavour = "mocha"`, `transparent_background = false`, `term_colors = true`, `priority = 1000`).
- **Integrações ativas**: `aerial`, `alpha`, `cmp`, `dashboard`, `flash`, `gitsigns`, `harpoon`, `headlines`, `illuminate`, `indent_blankline`, `leap`, `lsp_trouble`, `mason`, `markdown`, `mini`, `native_lsp` (`undercurl` para errors/hints/warnings/info), `navic`, `neotest`, `neotree`, `noice`, `notify`, `semantic_tokens`, `rainbow_delimiters`, `snacks`, `telescope`, `treesitter`, `treesitter_context`, `which_key`.
- **Custom Highlights**:
  - `@string.delimiter`: `pink`, `bold`
  - `@string.escape`: `red`, `bold`
  - `MatchParen`: `bg = surface2`, `fg = peach`, `bold`, `underline`
  - `SnacksIndentChunk`: `fg = sapphire`
  - `SnacksIndentScope`: `fg = mauve`

---

## 9. Treesitter (`lua/plugins/treesitter.lua`)

- **`nvim-treesitter/nvim-treesitter`**: `ensure_installed` deduplicado com 39 parsers:
  `bash`, `c`, `css`, `diff`, `dockerfile`, `go`, `gomod`, `gowork`, `gosum`, `html`, `hyprlang`, `java`, `javascript`, `json`, `json5`, `kdl`, `kotlin`, `lua`, `luadoc`, `luap`, `markdown`, `markdown_inline`, `python`, `query`, `regex`, `ron`, `rust`, `sql`, `http`, `graphql`, `prisma`, `toml`, `tsx`, `typescript`, `vim`, `vimdoc`, `xml`, `yaml`.
- **`nvim-treesitter/nvim-treesitter-context`** (Sticky Scroll):
  - `max_lines = 4`, `line_numbers = true`, `trim_scope = "outer"`, `mode = "cursor"`.
  - Atalhos: `[c` (pular para contexto superior) e `<leader>uc` (toggle sticky scroll).
