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
}
