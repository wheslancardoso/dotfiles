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
        { "<leader>u", group = "UI / Visual Toggles", icon = "󰔡 " },
        { "<leader>gm", group = "Git Conflicts / Merge", icon = " " },
        { "<leader>j", group = "Java (JDTLS)", icon = " " },
        { "<leader>jg", group = "Generate (Getters/Construtor)", icon = "󰏫 " },
        { "<leader>jm", group = "Maven / Spring Boot", icon = "󰔚 " },
        { "<leader>jr", group = "Refactor / Extração", icon = "󰑕 " },
        { "<leader>jt", group = "Test (JUnit)", icon = "󰙨 " },
      },
    },
  },

  -- 🧘 Zen Mode: Ambiente hiperfocado sem distrações
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode (Hiperfoco)" },
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = true,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
    },
  },

  -- 🔇 Noice: Silencia popups repetitivos de "Validating..." e progresso em segundo plano do JDTLS
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local title = vim.tbl_get(message.opts, "progress", "title") or ""
            local client = vim.tbl_get(message.opts, "progress", "client") or ""
            return client == "jdtls" or title:find("Validating") ~= nil
          end,
        },
        opts = { skip = true },
      })
    end,
  },

  -- 🌈 Rainbow Delimiters: Colorização hierárquica por profundidade de (), {}, []
  {
    "HiPhish/rainbow-delimiters.nvim",
    submodules = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- 🍿 Snacks: Indentação animada, Dimming e Smooth Scrolling amanteigado
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 200 },
          easing = "linear",
        },
        spamming = 10,
      },
      dim = {
        enabled = true,
      },
      indent = {
        enabled = true,
        priority = 1,
        char = "│",
        only_scope = false,
        only_current = false,
        scope = {
          enabled = true,
          priority = 200,
          char = "│",
          underline = true, -- sublinha o início do escopo ativo (ex: class, método, if, loop)
        },
        chunk = {
          enabled = true,
          priority = 200,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
        animate = {
          enabled = vim.fn.has("nvim-0.10") == 1,
          style = "out",
          duration = {
            step = 15,
            total = 250,
          },
        },
      },
    },
  },

  -- ⚡ Smear Cursor: Rastro elástico animado / feixe de luz pelo buffer estilo "Zap"
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      distance_stop_animating = 0.5,
      cursor_color = "#89dceb", -- Catppuccin Sky / Cyan Elétrico combinando com o rastro do Kitty
    },
  },

  -- 🌧️ Cellular Automaton: Efeito Físico de Chuva de Código, Gravidade e Game of Life
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>ur", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make It Rain (Chuva de Código)" },
      { "<leader>ug", "<cmd>CellularAutomaton game_of_life<cr>", desc = "Game of Life (Células Vivas)" },
      { "<leader>us", "<cmd>CellularAutomaton scramble<cr>", desc = "Scramble (Glitch Matrix)" },
    },
  },

  -- 🚨 Beacon: Flash de radar / sonar neon ao dar grandes saltos ou trocar de janela
  {
    "DanilaMihailov/beacon.nvim",
    event = "BufReadPost",
    opts = {
      enable = true,
      size = 35,
      fade = true,
      speed = 2,
      minimal_jump = 10,
      show_jumps = true,
      focus_gained = true,
    },
  },
}

