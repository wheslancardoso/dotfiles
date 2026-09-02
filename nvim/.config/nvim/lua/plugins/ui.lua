return {
  -- 🍞 Dropbar: Breadcrumbs clicáveis e navegáveis estilo VS Code no topo do buffer
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      bar = {
        enable = function(buf, win)
          return vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_win_is_valid(win)
            and vim.wo[win].winbar == ""
            and vim.bo[buf].buftype == ""
            and vim.bo[buf].filetype ~= ""
        end,
      },
    },
  },

  -- ⌨️ Which-Key com agrupamento de categorias sem atrito
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>D", group = "Database (Dadbod)", icon = " " },
        { "<leader>R", group = "REST API (Kulala)", icon = "󰖟 " },
        { "<leader>r", group = "Refactor", icon = "󰑕 " },
        { "<leader>F", group = "Flutter Mobile", icon = " " },
        { "<leader>a", group = "AI Agent (Antigravity)", icon = "󰚩 " },
      },
    },
  },
}
