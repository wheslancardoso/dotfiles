return {
  -- 🌐 REST API Client (Substituto do Postman / Insomnia / Bruno)
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      default_view = "body",
      default_env = "dev",
      debug = false,
      formatters = {
        json = { "jq", "." },
        xml = { "xmllint", "--format", "-" },
        html = { "prettier", "--parser", "html" },
      },
    },
    keys = {
      { "<leader>R", "", desc = "+REST/API (Kulala)", ft = { "http", "rest" } },
      { "<leader>Rr", "<cmd>lua require('kulala').run()<cr>", desc = "Executar Requisição HTTP", ft = { "http", "rest" } },
      { "<leader>Ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Executar Todas as Requisições", ft = { "http", "rest" } },
      { "<leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspecionar Requisição", ft = { "http", "rest" } },
      { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Alternar Body/Headers", ft = { "http", "rest" } },
      { "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copiar como cURL", ft = { "http", "rest" } },
      { "<leader>Re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Selecionar Ambiente (Dev/Prod)", ft = { "http", "rest" } },
    },
  },
}
