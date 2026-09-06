return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      local parsers = {
        "bash",
        "c",
        "css",
        "diff",
        "dockerfile",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "html",
        "hyprlang",
        "java",
        "javascript",
        "json",
        "json5",
        "kdl",
        "kotlin",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ron",
        "rust",
        "sql",
        "http",
        "graphql",
        "prisma",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      }
      local seen = {}
      local deduplicated = {}
      for _, p in ipairs(opts.ensure_installed) do
        if not seen[p] then
          seen[p] = true
          table.insert(deduplicated, p)
        end
      end
      for _, p in ipairs(parsers) do
        if not seen[p] then
          seen[p] = true
          table.insert(deduplicated, p)
        end
      end
      opts.ensure_installed = deduplicated
    end,
  },

  -- 📌 Treesitter Context: Sticky scroll mostrando a assinatura da função/classe no topo
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 4,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Pular para Contexto Superior (Treesitter)",
      },
      {
        "<leader>uc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Contexto Sticky Scroll",
      },
    },
  },
}
