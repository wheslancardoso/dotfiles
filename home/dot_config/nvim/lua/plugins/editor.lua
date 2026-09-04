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
}


