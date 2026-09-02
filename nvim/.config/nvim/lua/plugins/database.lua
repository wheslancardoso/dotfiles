return {
  -- 🗄️ Database Management Suite (Substituto completo do DBeaver / DataGrip)
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Configurações da UI do Dadbod
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_winwidth = 35
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = "select count(*) from {table}",
          Structure = "\\d+ {table}",
        },
      }
    end,
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Database UI (Dadbod)" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Localizar buffer de DB" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Adicionar conexão DB" },
    },
  },
}
