return {
  -- Mason para gerenciamento automatizado de LSPs, linters e formatadores
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      local to_add = {
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
      }
      local seen = {}
      local deduplicated = {}
      for _, item in ipairs(opts.ensure_installed) do
        if not seen[item] then
          seen[item] = true
          table.insert(deduplicated, item)
        end
      end
      for _, item in ipairs(to_add) do
        if not seen[item] then
          seen[item] = true
          table.insert(deduplicated, item)
        end
      end
      opts.ensure_installed = deduplicated
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and p and not p:is_installed() and not p:is_installing() then
            pcall(p.install, p)
          end
        end
      end)
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
