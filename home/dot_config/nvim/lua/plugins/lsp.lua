return {
  -- Mason para gerenciamento automatizado de LSPs, linters e formatadores
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "vtsls",
        "angular-language-server",
        "html-lsp",
        "emmet-ls",
        "tailwindcss-language-server",
        "prettier",
        "pyright",
        "ruff",
        "black",
        "debugpy",
        "rust-analyzer",
        "gopls",
        "delve",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "shfmt",
        "stylua",
      })
    end,
  },

  -- Configuração adicional de servidores LSP (Angular, HTML, Emmet)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {},
        html = {},
        emmet_ls = {
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
        },
      },
    },
  },
}
