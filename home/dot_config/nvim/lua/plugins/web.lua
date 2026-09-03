return {
  -- 🎨 Colorizer: Renderiza amostras de cores inline para Hex, RGB, HSL e TailwindCSS
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
      },
    },
  },

  -- 📱 Flutter & Dart Tools para Neovim
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    ft = { "dart" },
    opts = {
      ui = {
        border = "rounded",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      widget_guides = {
        enabled = true,
      },
      lsp = {
        color = {
          enabled = true,
        },
      },
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterReload<cr>", desc = "Flutter Hot Reload", ft = "dart" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter Hot Restart", ft = "dart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter Dispositivos", ft = "dart" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter Emuladores", ft = "dart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Encerrar Flutter App", ft = "dart" },
    },
  },
}
