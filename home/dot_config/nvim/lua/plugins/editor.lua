return {
  -- 🔄 Auto-tag: Fecha e renomeia tags HTML/JSX/TSX/XML automaticamente
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },

  -- 🎯 Surround: Manipulação cirúrgica de aspas, parênteses e tags
  -- Exemplos:
  --   ysiw" -> envolve palavra com aspas
  --   cs"'  -> troca aspas duplas por simples
  --   ds"   -> remove aspas
  --   ysit<p> -> envolve bloco com <p>...</p>
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- 🔀 Split & Join: Transforma arrays/objetos de linha única em multi-linha (e vice-versa)
  -- Atalho: gS
  {
    "nvim-mini/mini.splitjoin",
    event = "VeryLazy",
    config = function()
      require("mini.splitjoin").setup()
    end,
  },

  -- 📏 Align: Alinhamento instantâneo de código por '=', ':', ',' etc.
  -- Atalho: ga
  {
    "nvim-mini/mini.align",
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end,
  },

  -- 🛠️ Refactoring Suite: Extração de métodos, variáveis e inline
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>re", "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", mode = "v", desc = "Extrair Função" },
      { "<leader>rf", "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", mode = "v", desc = "Extrair Função para Arquivo" },
      { "<leader>rv", "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", mode = "v", desc = "Extrair Variável" },
      { "<leader>ri", "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", mode = { "n", "v" }, desc = "Inline Variável" },
      { "<leader>rb", "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", mode = "n", desc = "Extrair Bloco" },
    },
    config = function()
      require("refactoring").setup()
    end,
  },

  -- 📝 Todo Comments: Realce e busca rápida de TODOs, FIXMEs, BUGs
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Próximo TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "TODO anterior" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Buscar TODOs no Projeto" },
    },
  },

  -- 💾 Persistence: Salva e restaura sessões automaticamente por diretório/projeto
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restaurar Sessão do Projeto" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restaurar Última Sessão" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Não Salvar Sessão Atual" },
    },
  },

  -- 🎮 Vim-Be-Good: Game interativo para treinar memória muscular de Vim
  -- Como jogar: :VimBeGood
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  -- ⏳ UndoTree: Máquina do tempo visual para histórico ramificado de edições
  -- Permite desfazer edições mesmo após fechar o arquivo ou fazer modificações em galhos separados
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree (Histórico Ramificado)" },
    },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
    end,
  },

  -- 🤹 Visual Multi: Multi-cursor inteligente com vocabulário completo do Vim
  -- Atalhos: Ctrl+N (seleciona palavra / próxima ocorrência), Ctrl+Down/Up (adiciona cursor vertical)
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
      }
    end,
  },

  -- 🔁 Substitute & Exchange: Substituição sem poluir registradores e troca cirúrgica de posições
  -- gs{motion} -> substitui texto com o registrador atual sem sobrescrever clipboard
  -- gss        -> substitui linha inteira
  -- cx{motion} -> marca primeiro elemento para troca; no segundo cx{motion}, permuta ambos de lugar
  -- cxx        -> troca linha inteira
  -- cxc        -> cancela troca pendente
  {
    "gbprod/substitute.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "gs", function() require("substitute").operator() end, desc = "Substituir com Registrador" },
      { "gss", function() require("substitute").line() end, desc = "Substituir Linha com Registrador" },
      { "gs", function() require("substitute").visual() end, mode = "x", desc = "Substituir Seleção com Registrador" },
      { "cx", function() require("substitute.exchange").operator() end, desc = "Trocar (Exchange) Operador" },
      { "cxx", function() require("substitute.exchange").line() end, desc = "Trocar Linha com outra" },
      { "cxc", function() require("substitute.exchange").cancel() end, desc = "Cancelar Troca Pendente" },
      { "X", function() require("substitute.exchange").visual() end, mode = "x", desc = "Trocar Seleção com outra" },
    },
  },

  -- ⚡ Autocompletion (blink.cmp) - Super-Tab Inteligente & Navegação estilo Vim
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<NL>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "fallback" }, -- Enter apenas quebra linha, sem acidentes
      },
    },
  },

  -- 🪆 Mini.Pairs: Auto-fechamento limpo estilo VS Code para "", '', [], {} e ()
  {
    "nvim-mini/mini.pairs",
    opts = {
      -- Permite que {}, [], (), "" e '' fechem normalmente em qualquer lugar (inclusive dentro de strings)
      skip_ts = {},
      -- Remove aspas do skip_next para permitir abrir {, [ e ( mesmo encostado em aspas
      skip_next = [=[[%w%%%[%.%`%$]]=],
    },
    config = function(_, opts)
      LazyVim.mini.pairs(opts)

      local pairs = require("mini.pairs")
      local orig_closeopen = pairs.closeopen
      local orig_bs = pairs.bs
      local escape = function(s)
        return vim.api.nvim_replace_termcodes(s, true, true, true)
      end

      -- 1. Ao digitar aspas após barra invertida (\"), insere as aspas literais sem pular a aspas final da string
      pairs.closeopen = function(pair, neigh_pattern)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local col = cursor[2]
        local line_before = line:sub(1, col)
        local backslashes = line_before:match("\\+$")
        local is_escaped = backslashes and (#backslashes % 2 == 1)

        if is_escaped then
          return pair:sub(1, 1)
        end

        return orig_closeopen(pair, neigh_pattern)
      end

      -- 2. Backspace limpo: não deleta a aspas de fechamento da string se o caractere apagado for escapado (\")
      pairs.bs = function(key)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local col = cursor[2]
        local line_before = line:sub(1, col)
        local line_after = line:sub(col + 1)

        -- Se a aspas à esquerda for escapada (\"), ela não faz par com a aspas da direita.
        -- Deleta apenas a aspas da esquerda sem comer a da direita!
        if line_before:sub(-1) == '"' and line_after:sub(1, 1) == '"' then
          local before_slice = line_before:sub(1, -2)
          local backslashes = before_slice:match("\\+$")
          local is_left_escaped = backslashes and (#backslashes % 2 == 1)
          if is_left_escaped then
            return escape("<BS>")
          end
        end

        return orig_bs(key)
      end
    end,
  },

}
