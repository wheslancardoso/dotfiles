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

  -- 🍿 Snacks Indent: Guias de indentação com escopos visuais em chunk (╭ ─ │ ╰) e animação
  {
    "folke/snacks.nvim",
    opts = {
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
}
