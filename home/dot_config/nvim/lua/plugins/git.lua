return {
  -- 🔍 Diffview.nvim para resolução visual de merge conflicts e histórico de Git
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview (Diff do Projeto)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Histórico do Arquivo (Git History)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Histórico de Commits do Branch" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Fechar Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      },
    },
  },

  -- 🌿 Gitsigns: visualizador e ações de hunks na signcolumn
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- Mostra autor e commit inline na linha atual
      current_line_blame_opts = {
        delay = 300,
      },
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },

  -- ⚔️ Git Conflict: Resolução instantânea de merge conflicts sem mouse e com supressão de erros de sintaxe
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      default_mappings = true, -- Ativa: co (ours), ct (theirs), cb (both), c0 (none), ]x (next), [x (prev)
      default_commands = true,
      disable_diagnostics = true, -- Silencia erros de LSP no bloco conflitante para visualização limpa
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
    keys = {
      { "<leader>gmo", "<cmd>GitConflictChooseOurs<cr>", desc = "Escolher Nosso (Current/Ours) [co]" },
      { "<leader>gmt", "<cmd>GitConflictChooseTheirs<cr>", desc = "Escolher Deles (Incoming/Theirs) [ct]" },
      { "<leader>gmb", "<cmd>GitConflictChooseBoth<cr>", desc = "Manter Ambos (Both) [cb]" },
      { "<leader>gm0", "<cmd>GitConflictChooseNone<cr>", desc = "Descartar Ambos (None) [c0]" },
      { "<leader>gmn", "<cmd>GitConflictNextConflict<cr>", desc = "Próximo Conflito (]x)" },
      { "<leader>gmp", "<cmd>GitConflictPrevConflict<cr>", desc = "Conflito Anterior ([x)" },
      { "<leader>gml", "<cmd>GitConflictListQf<cr>", desc = "Listar Conflitos no Projeto (Quickfix)" },
      { "<leader>gmd", "<cmd>DiffviewOpen<cr>", desc = "Abrir 3-Way Diffview Merge Tool" },
    },
  },
}
