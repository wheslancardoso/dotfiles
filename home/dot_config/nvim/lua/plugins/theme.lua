return {
  -- Configuração do tema Catppuccin Mocha integrado com o visual do Hyprland
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      term_colors = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        harpoon = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        rainbow_delimiters = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          -- 🎯 Destaque cirúrgico para aspas de strings (" e ') separando da string interna
          ["@string.delimiter"] = { fg = colors.pink, bold = true },
          ["@string.escape"] = { fg = colors.red, bold = true },
          -- 🔍 Destaque de alto contraste para o par de delimitadores sob o cursor (), {}, []
          MatchParen = { bg = colors.surface2, fg = colors.peach, bold = true, underline = true },
          -- 📦 Linhas de conexão visual do bloco / escopo ativo (Snacks Chunk)
          SnacksIndentChunk = { fg = colors.sapphire },
          SnacksIndentScope = { fg = colors.mauve },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
