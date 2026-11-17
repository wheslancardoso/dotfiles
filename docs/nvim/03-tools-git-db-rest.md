# Ferramentas Integradas: Banco de Dados, Git e REST

Documentação das ferramentas de **Banco de Dados**, **Git** e **REST** configuradas no Neovim, baseada em [`database.lua`](file:///home/lanwsl/dotfiles/home/dot_config/nvim/lua/plugins/database.lua), [`git.lua`](file:///home/lanwsl/dotfiles/home/dot_config/nvim/lua/plugins/git.lua), [`rest.lua`](file:///home/lanwsl/dotfiles/home/dot_config/nvim/lua/plugins/rest.lua) e [`lazy-lock.json`](file:///home/lanwsl/dotfiles/home/dot_config/nvim/lazy-lock.json).

---

## 1. Banco de Dados (`database.lua`)

A suíte de banco de dados utiliza **vim-dadbod** em conjunto com **vim-dadbod-ui** e **vim-dadbod-completion**.

### Plugins e Dependências
- `tpope/vim-dadbod` (`lazy = true`)
- `kristijanhusak/vim-dadbod-ui`
  - Dependências: `tpope/vim-dadbod` (`lazy = true`) e `kristijanhusak/vim-dadbod-completion` (`ft = { "sql", "mysql", "plsql" }`, `lazy = true`)

### Keymaps
| Atalho | Comando | Descrição |
| :--- | :--- | :--- |
| `<leader>D` | `:DBUIToggle` | Abre ou fecha a interface do Dadbod (Toggle Database UI) |

### Comandos Disponíveis
- `:DBUI` — Abre a interface do Dadbod UI.
- `:DBUIToggle` — Alterna a visibilidade da interface do Dadbod UI.
- `:DBUIAddConnection` — Adiciona uma nova conexão de banco de dados.
- `:DBUIFindBuffer` — Localiza o buffer atual na árvore do Dadbod UI.

### Configurações e Conexões (`init`)
- `vim.g.db_ui_use_nerd_fonts = 1`
- `vim.g.db_ui_show_database_icon = 1`
- `vim.g.db_ui_force_echo_notifications = 1`
- `vim.g.db_ui_winwidth = 35`
- **Conexão pré-configurada (`vim.g.dbs`)**:
  - `fiscalizacao`: `mysql://root:root@127.0.0.1:3306/fiscalizacao`
- **Table Helpers (`vim.g.db_ui_table_helpers.postgresql`)**:
  - `Count`: `select count(*) from {table}`
  - `Structure`: `\d+ {table}`

### Workflow Típico
1. Pressione `<leader>D` para abrir o painel lateral do Dadbod UI.
2. Selecione a conexão `fiscalizacao` (ou adicione uma nova com `:DBUIAddConnection`).
3. Abra um buffer SQL (`sql`, `mysql` ou `plsql`) para contar com autocompletar via `vim-dadbod-completion`.

---

## 2. Git (`git.lua`)

A configuração de Git em [`git.lua`](file:///home/lanwsl/dotfiles/home/dot_config/nvim/lua/plugins/git.lua) reúne **diffview.nvim**, **gitsigns.nvim** e **git-conflict.nvim**.

### 2.1 Diffview (`sindrets/diffview.nvim`)

#### Keymaps
| Atalho | Comando | Descrição |
| :--- | :--- | :--- |
| `<leader>gd` | `:DiffviewOpen` | Diffview (Diff do Projeto) |
| `<leader>gh` | `:DiffviewFileHistory %` | Histórico do Arquivo (Git History) |
| `<leader>gH` | `:DiffviewFileHistory` | Histórico de Commits do Branch |
| `<leader>gq` | `:DiffviewClose` | Fechar Diffview |

#### Comandos Disponíveis
- `:DiffviewOpen`
- `:DiffviewClose`
- `:DiffviewToggleFiles`
- `:DiffviewFocusFiles`
- `:DiffviewFileHistory`

#### Opções (`opts`)
- `enhanced_diff_hl = true`
- `use_icons = true`
- `view.default.layout = "diff2_horizontal"`
- `view.merge_tool.layout = "diff3_horizontal"` (com `disable_diagnostics = true`)

### 2.2 Gitsigns (`lewis6991/gitsigns.nvim`)

- `current_line_blame = true` (exibe autor e commit inline na linha atual, com `delay = 300` ms).
- Sinais configurados na *signcolumn*:
  - `add`: `▎`
  - `change`: `▎`
  - `delete`: ``
  - `topdelete`: ``
  - `changedelete`: `▎`
  - `untracked`: `▎`

### 2.3 Git Conflict (`akinsho/git-conflict.nvim`)

Carregado nos eventos `BufReadPre` e `BufNewFile` (`version = "*"`).

#### Keymaps
| Atalho | Atalho Padrão | Comando | Descrição |
| :--- | :--- | :--- | :--- |
| `<leader>gmo` | `co` | `:GitConflictChooseOurs` | Escolher Nosso (Current/Ours) |
| `<leader>gmt` | `ct` | `:GitConflictChooseTheirs` | Escolher Deles (Incoming/Theirs) |
| `<leader>gmb` | `cb` | `:GitConflictChooseBoth` | Manter Ambos (Both) |
| `<leader>gm0` | `c0` | `:GitConflictChooseNone` | Descartar Ambos (None) |
| `<leader>gmn` | `]x` | `:GitConflictNextConflict` | Próximo Conflito |
| `<leader>gmp` | `[x` | `:GitConflictPrevConflict` | Conflito Anterior |
| `<leader>gml` | — | `:GitConflictListQf` | Listar Conflitos no Projeto (Quickfix) |
| `<leader>gmd` | — | `:DiffviewOpen` | Abrir 3-Way Diffview Merge Tool |

#### Opções (`opts`)
- `default_mappings = true`
- `default_commands = true`
- `disable_diagnostics = true` (silencia erros de LSP no bloco conflitante)
- `list_opener = "copen"`
- `highlights`: `incoming = "DiffAdd"`, `current = "DiffText"`

#### Workflow de Resolução de Conflitos
1. Liste todos os conflitos no Quickfix com `<leader>gml` ou navegue entre eles com `<leader>gmn` (`]x`) e `<leader>gmp` (`[x`).
2. Resolva diretamente no buffer com `<leader>gmo` (`co`), `<leader>gmt` (`ct`), `<leader>gmb` (`cb`) ou `<leader>gm0` (`c0`).
3. Para uma visão 3-way lado a lado, abra o Diffview Merge Tool com `<leader>gmd` e feche com `<leader>gq`.

---

## 3. REST / API Client (`rest.lua`)

O cliente REST utiliza **kulala.nvim** (`mistweaverco/kulala.nvim`), ativado automaticamente para arquivos `http` e `rest`.

### Keymaps (`ft = { "http", "rest" }`)
| Atalho | Ação | Descrição |
| :--- | :--- | :--- |
| `<leader>R` | — | Prefixo `+REST/API (Kulala)` |
| `<leader>Rr` | `require('kulala').run()` | Executar Requisição HTTP |
| `<leader>Ra` | `require('kulala').run_all()` | Executar Todas as Requisições |
| `<leader>Ri` | `require('kulala').inspect()` | Inspecionar Requisição |
| `<leader>Rt` | `require('kulala').toggle_view()` | Alternar Body/Headers |
| `<leader>Rc` | `require('kulala').copy()` | Copiar como cURL |
| `<leader>Re` | `require('kulala').set_selected_env()` | Selecionar Ambiente (Dev/Prod) |

### Opções (`opts`)
- `default_view = "body"`
- `default_env = "dev"`
- `debug = false`
- `formatters`:
  - `json`: `{ "jq", "." }`
  - `xml`: `{ "xmllint", "--format", "-" }`
  - `html`: `{ "prettier", "--parser", "html" }`

### Workflow Típico
1. Abra um arquivo `.http` ou `.rest`.
2. Selecione o ambiente desejado com `<leader>Re` (padrão: `dev`).
3. Execute a requisição sob o cursor com `<leader>Rr` ou todas do arquivo com `<leader>Ra`.
4. Alterne entre corpo e cabeçalhos da resposta com `<leader>Rt`, inspecione com `<leader>Ri` ou copie como `cURL` com `<leader>Rc`.

---

## 4. Inventário Conciso de Plugins (`lazy-lock.json`)

O arquivo [`lazy-lock.json`](file:///home/lanwsl/dotfiles/home/dot_config/nvim/lazy-lock.json) registra **79** plugins no total. Abaixo estão os plugins correspondentes às ferramentas documentadas neste guia:

| Categoria | Plugin | Branch | Commit |
| :--- | :--- | :--- | :--- |
| Banco de Dados | `vim-dadbod` | `master` | `6d1d41da4873a445c5605f2005ad2c68c99d8770` |
| Banco de Dados | `vim-dadbod-completion` | `master` | `a8dac0b3cf6132c80dc9b18bef36d4cf7a9e1fe6` |
| Banco de Dados | `vim-dadbod-ui` | `master` | `afd07819d8efcefc3317205b855ad4e3513b0011` |
| Git | `diffview.nvim` | `main` | `4516612fe98ff56ae0415a259ff6361a89419b0a` |
| Git | `git-conflict.nvim` | `main` | `4bbfdd92d547d2862a75b4e80afaf30e73f7bbb4` |
| Git | `gitsigns.nvim` | `main` | `fd780920613e541cbdfac41bf711583ed49f9249` |
| REST | `kulala.nvim` | `main` | `eebe4464c8937ad7313008a8b690e63d140d6638` |
