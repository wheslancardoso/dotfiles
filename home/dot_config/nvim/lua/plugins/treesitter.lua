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
}
