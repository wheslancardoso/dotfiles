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

  -- 🔥 Smear Cursor (Fogo Moderado): Rastro laranja suave sem travar o terminal e sem cobrir o texto
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      cursor_color = "#ff4000",
      time_interval = 17,
      particles_enabled = true,
      particles_over_text = false,
      particle_max_num = 80,
      particles_per_second = 150,
      particles_per_length = 15,
      particle_max_lifetime = 450,
      particle_gravity = -50,
      min_distance_emit_particles = 0,
      stiffness = 0.7,
      trailing_stiffness = 0.4,
      damping = 0.75,
      never_draw_over_target = true,
      hide_target_hack = true,
    },
  },

  -- ✨ Tiny Glimmer: Animações em tons de fogo ao copiar (yank), colar, desfazer, refazer e buscar
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    opts = {
      disable_warnings = true,
      overwrite = {
        auto_map = true,
        yank = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "#ff4000",
              max_duration = 400,
              min_duration = 250,
            },
          },
        },
        paste = {
          enabled = true,
          default_animation = {
            name = "reverse_fade",
            settings = {
              from_color = "#ff8800",
              max_duration = 400,
              min_duration = 250,
            },
          },
          paste_mapping = "p",
          Paste_mapping = "P",
        },
        undo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "#ff2200",
              max_duration = 400,
              min_duration = 300,
            },
          },
          undo_mapping = "u",
        },
        redo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "#ffaa00",
              max_duration = 400,
              min_duration = 300,
            },
          },
          redo_mapping = "<c-r>",
        },
        search = {
          enabled = true,
          default_animation = {
            name = "pulse",
            settings = {
              from_color = "#ff5500",
              max_duration = 500,
              min_duration = 300,
            },
          },
          next_mapping = "n",
          prev_mapping = "N",
        },
      },
    },
  },

  -- 🔥 Power Mode: Combo estilo Guitar Hero + partículas + Fire Wall + Tema dinâmico por streak
  {
    "axsaucedo/neovim-power-mode",
    event = "InsertEnter",
    opts = {
      particles = {
        preset = "rightburst",
        avoid_cursor = true,
      },
      combo = {
        enabled = true,
        position = "top-right",
        timeout = 8000,
        combo_box_disappear_seconds = 4,
        thresholds = { 10, 25, 50, 80, 120 },
      },
      fire_wall = {
        enabled = true,
        bottom_offset = 1,
        max_rows = 2,
      },
      shake = {
        mode = "none",
      },
    },
    config = function(_, opts)
      require("power-mode").setup(opts)

      local last_level = 0
      local streak = 0
      local thresholds = { 10, 25, 50, 80, 120, 150, 180, 210, 250, 300 }
      vim.g.power_preset = vim.g.power_preset or "fire"
      vim.g.power_ascended = false

      local function streak_to_level(s)
        local max_lvl = (vim.g.power_preset == "fire") and 10 or 5
        local lvl = 0
        for i = 1, max_lvl do
          if s >= thresholds[i] then
            lvl = i
          end
        end
        return lvl
      end

      local presets = {
        fire = {
          smear_color = "#ff4000",
          levels = {
            [1] = {
              scheme = "tokyonight-night",
              fg = "#39ff14",
              bg = "#14261c",
              editor_bg = "#111a15",
              flash_bg = "#1e3d28",
              label = "⚡ LEVEL 1: OVERDRIVE (10+)",
            },
            [2] = {
              scheme = "tokyonight-storm",
              fg = "#ffd700",
              bg = "#2b2410",
              editor_bg = "#1c180e",
              flash_bg = "#473a15",
              label = "🌟 LEVEL 2: SUPER SAIYAN (25+)",
            },
            [3] = {
              scheme = "catppuccin-frappe",
              fg = "#ff8800",
              bg = "#2e1a0d",
              editor_bg = "#24130a",
              flash_bg = "#52280e",
              label = "🔥 LEVEL 3: ON FIRE (50+)",
            },
            [4] = {
              scheme = "catppuccin-mocha",
              fg = "#ff4000",
              bg = "#3d1208",
              editor_bg = "#290b05",
              flash_bg = "#611909",
              label = "🌋 LEVEL 4: INFERNO (80+)",
            },
            [5] = {
              scheme = "catppuccin-mocha",
              fg = "#ff0055",
              bg = "#420820",
              editor_bg = "#260513",
              flash_bg = "#660a30",
              label = "💀 LEVEL 5: GODLIKE (120+)",
            },
          },
        },
        heaven = {
          smear_color = "#00f5ff",
          levels = {
            [1] = {
              scheme = "tokyonight-night",
              fg = "#00f5ff",
              bg = "#0c222e",
              editor_bg = "#0a1721",
              flash_bg = "#12384d",
              label = "💎 LEVEL 1: NEON PULSE (10+)",
            },
            [2] = {
              scheme = "tokyonight-moon",
              fg = "#7aa2f7",
              bg = "#141c38",
              editor_bg = "#0f1429",
              flash_bg = "#1f2c59",
              label = "⚡ LEVEL 2: HYPERION (25+)",
            },
            [3] = {
              scheme = "catppuccin-macchiato",
              fg = "#c792ea",
              bg = "#241638",
              editor_bg = "#1a102b",
              flash_bg = "#3b215c",
              label = "🔮 LEVEL 3: ULTRAVIOLET (50+)",
            },
            [4] = {
              scheme = "catppuccin-mocha",
              fg = "#ff2cf1",
              bg = "#301036",
              editor_bg = "#210926",
              flash_bg = "#4f1459",
              label = "🌌 LEVEL 4: NEON HEAVEN (80+)",
            },
            [5] = {
              scheme = "catppuccin-mocha",
              fg = "#fff3b0",
              bg = "#2b2a40",
              editor_bg = "#1e1d30",
              flash_bg = "#4c4a6e",
              label = "👑 LEVEL 5: CELESTIAL (120+)",
            },
          },
        },
      }

      local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
      end

      local function lerp_hex(c1, c2, alpha)
        local r1, g1, b1 = hex_to_rgb(c1)
        local r2, g2, b2 = hex_to_rgb(c2)
        local r = math.floor(r1 + (r2 - r1) * alpha + 0.5)
        local g = math.floor(g1 + (g2 - g1) * alpha + 0.5)
        local b = math.floor(b1 + (b2 - b1) * alpha + 0.5)
        return string.format("#%02x%02x%02x", r, g, b)
      end

      local current_bg = "#1e1e2e"
      local anim_timer = vim.uv.new_timer()
      local pulse_timer = vim.uv.new_timer()

      local function stop_pulse()
        if pulse_timer then
          pulse_timer:stop()
        end
      end

      local function start_celestial_pulse(t)
        stop_pulse()
        if not pulse_timer then
          return
        end
        local phase = 0
        pulse_timer:start(
          250,
          60,
          vim.schedule_wrap(function()
            local is_max = (vim.g.power_preset == "fire" and last_level >= 10)
              or (vim.g.power_preset == "heaven" and last_level >= 5)
            if not is_max then
              stop_pulse()
              return
            end
            phase = phase + 0.18
            local alpha = (math.sin(phase) + 1) * 0.5
            local fg = lerp_hex("#fff3b0", "#00f5ff", alpha)
            vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = fg, bg = t.editor_bg })
            vim.api.nvim_set_hl(0, "WinSeparator", { fg = fg })
            vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg, bg = t.editor_bg })
            vim.api.nvim_set_hl(0, "StatusLine", { fg = fg, bg = t.bg, bold = true })
            vim.api.nvim_set_hl(0, "CursorLineNr", { fg = fg, bg = t.bg, bold = true })
            vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = fg })
          end)
        )
      end

      local function paint_chrome(bg, fg, line_bg, visual_bg)
        for _, name in ipairs({
          "Normal",
          "NormalNC",
          "SignColumn",
          "EndOfBuffer",
          "NormalFloat",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "NeoTreeEndOfBuffer",
        }) do
          vim.api.nvim_set_hl(0, name, { bg = bg })
        end
        vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = fg, bg = bg })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = line_bg })
        vim.api.nvim_set_hl(0, "LineNr", { fg = fg, bg = bg })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = line_bg, bold = true })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = fg })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg, bg = bg })
        vim.api.nvim_set_hl(0, "StatusLine", { fg = fg, bg = line_bg, bold = true })
        vim.api.nvim_set_hl(0, "Visual", { bg = visual_bg })
        vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = fg })
        vim.api.nvim_set_hl(0, "MatchParen", { bg = line_bg, fg = fg, bold = true, underline = true })
      end

      local function animate_transition(from_bg, peak_bg, to_bg, fg, line_bg, on_done)
        if anim_timer then
          anim_timer:stop()
        end
        local step = 0
        local total = 10
        if anim_timer then
          anim_timer:start(
            0,
            22,
            vim.schedule_wrap(function()
              step = step + 1
              local bg
              if step <= 3 then
                bg = lerp_hex(from_bg, peak_bg, step / 3)
              else
                bg = lerp_hex(peak_bg, to_bg, (step - 3) / (total - 3))
              end
              current_bg = bg
              paint_chrome(bg, fg, line_bg, peak_bg)
              if step >= total then
                anim_timer:stop()
                if on_done then
                  on_done()
                end
              end
            end)
          )
        end
      end

      local pm_particles = require("power-mode.particles")
      local current_fx_heaven = nil
      local shock_ns = vim.api.nvim_create_namespace("PowerModeShockwave")

      local function sync_kitty(fg, bg)
        if not vim.env.KITTY_WINDOW_ID or vim.fn.executable("kitty") ~= 1 then
          return
        end
        if not fg then
          pcall(vim.system, { "kitty", "@", "set-colors", "--reset" })
          return
        end
        pcall(vim.system, {
          "kitty",
          "@",
          "set-colors",
          "active_border_color=" .. fg,
          "active_tab_background=" .. fg,
          "cursor=" .. fg,
          "background=" .. bg,
        })
      end

      local function level_up_shockwave(fg, flash_bg)
        pcall(function()
          require("beacon").highlight_cursor()
        end)
        local buf = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
          return
        end
        local total_lines = vim.api.nvim_buf_line_count(buf)
        local center = vim.api.nvim_win_get_cursor(0)[1] - 1
        local rings = {
          { offsets = { 0 }, delay = 0, hl = "PowerModeShockwave0", bg = flash_bg },
          { offsets = { -1, 1 }, delay = 45, hl = "PowerModeShockwave1", bg = lerp_hex(flash_bg, current_bg, 0.4) },
          { offsets = { -2, 2 }, delay = 90, hl = "PowerModeShockwave2", bg = lerp_hex(flash_bg, current_bg, 0.7) },
        }
        for _, ring in ipairs(rings) do
          vim.api.nvim_set_hl(0, ring.hl, { bg = ring.bg, fg = fg, bold = (ring.delay == 0) })
          vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(buf) then
              return
            end
            for _, off in ipairs(ring.offsets) do
              local r = center + off
              if r >= 0 and r < total_lines then
                local ok, mark_id = pcall(vim.api.nvim_buf_set_extmark, buf, shock_ns, r, 0, {
                  line_hl_group = ring.hl,
                  priority = 250,
                })
                if ok and mark_id then
                  vim.defer_fn(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                      pcall(vim.api.nvim_buf_del_extmark, buf, shock_ns, mark_id)
                    end
                  end, 160)
                end
              end
            end
          end, ring.delay)
        end
      end

      local function apply_wall_gradient(fg, bg)
        if not fg or not bg then
          return
        end
        vim.api.nvim_set_hl(0, "PowerModeFire1", { fg = lerp_hex(fg, "#ffffff", 0.55), bold = true })
        vim.api.nvim_set_hl(0, "PowerModeFire2", { fg = fg })
        vim.api.nvim_set_hl(0, "PowerModeFire3", { fg = lerp_hex(fg, bg, 0.25) })
        vim.api.nvim_set_hl(0, "PowerModeFire4", { fg = lerp_hex(fg, bg, 0.50) })
        vim.api.nvim_set_hl(0, "PowerModeFire5", { fg = lerp_hex(fg, bg, 0.72) })
      end

      local function apply_fx_mode(is_heaven, fg, bg)
        if fg and bg then
          apply_wall_gradient(fg, bg)
        end
        if current_fx_heaven == is_heaven then
          return
        end
        current_fx_heaven = is_heaven
        pcall(function()
          require("smear_cursor").setup({
            cursor_color = is_heaven and "#00f5ff" or "#ff4000",
            particle_gravity = is_heaven and 5 or -50,
          })
        end)
        pcall(function()
          local target_mode = is_heaven and "stars" or "rightburst"
          if pm_particles.get_mode() ~= target_mode then
            pm_particles.set_mode(target_mode)
          end
        end)
      end

      local function apply_level(level)
        if level == last_level then
          return
        end
        local leveled_up = level > last_level
        local from_bg = current_bg
        last_level = level

        if level <= 0 then
          stop_pulse()
          vim.g.power_ascended = false
          sync_kitty(nil, nil)
          local is_heaven_preset = (vim.g.power_preset == "heaven")
          animate_transition(from_bg, from_bg, "#1e1e2e", "#cdd6f4", "#313244", function()
            current_bg = "#1e1e2e"
            pcall(vim.cmd.colorscheme, "catppuccin-mocha")
            apply_fx_mode(is_heaven_preset)
          end)
          return
        end

        local preset_name = vim.g.power_preset
        local t
        local phase_title = preset_name
        local is_heaven_now = (preset_name == "heaven") or (preset_name == "fire" and level >= 6)
        if preset_name == "fire" and level >= 6 then
          vim.g.power_ascended = true
          t = presets.heaven.levels[math.min(level - 5, 5)]
          phase_title = "fire → heaven"
        else
          vim.g.power_ascended = false
          local active = presets[preset_name] or presets.fire
          t = active.levels[math.min(level, 5)]
        end

        pcall(vim.cmd.colorscheme, t.scheme)
        apply_fx_mode(is_heaven_now, t.fg, t.editor_bg)
        sync_kitty(t.fg, t.editor_bg)

        if leveled_up then
          vim.notify(t.label, vim.log.levels.INFO, { title = "Power Mode (" .. phase_title .. ")" })
          level_up_shockwave(t.fg, t.flash_bg)
          animate_transition(from_bg, t.flash_bg, t.editor_bg, t.fg, t.bg, function()
            local is_max = (preset_name == "fire" and level >= 10) or (preset_name == "heaven" and level >= 5)
            if is_max then
              start_celestial_pulse(t)
            end
          end)
        else
          current_bg = t.editor_bg
          paint_chrome(t.editor_bg, t.fg, t.bg, t.flash_bg)
          local is_max = (preset_name == "fire" and level >= 10) or (preset_name == "heaven" and level >= 5)
          if is_max then
            start_celestial_pulse(t)
          else
            stop_pulse()
          end
        end
      end

      local function set_preset(name)
        if not name or name == "" then
          name = (vim.g.power_preset == "fire") and "heaven" or "fire"
        end
        if not presets[name] then
          vim.notify("Preset inválido: use 'fire' ou 'heaven'", vim.log.levels.WARN)
          return
        end
        vim.g.power_preset = name
        local is_heaven_now = (name == "heaven") or (name == "fire" and last_level >= 6)
        apply_fx_mode(is_heaven_now)
        if last_level > 0 then
          local cur = last_level
          last_level = 0
          apply_level(cur)
        end
        local icon = (name == "heaven") and "✨" or "🔥"
        vim.notify(icon .. " Power Mode Preset: " .. name:upper(), vim.log.levels.INFO, { title = "Power Mode" })
      end

      vim.api.nvim_create_user_command("PowerPreset", function(cmd)
        set_preset(cmd.args)
      end, {
        nargs = "?",
        complete = function()
          return { "fire", "heaven" }
        end,
        desc = "Alterna preset do Power Mode (fire / heaven)",
      })

      vim.keymap.set("n", "<leader>uP", function()
        set_preset()
      end, { desc = "Toggle Power Mode Preset (Fire / Heaven)" })

      -- Impede o neovim-power-mode de zerar o combo/fire_wall ao apertar <Esc>
      pcall(vim.api.nvim_clear_autocmds, { group = "PowerMode", event = "InsertLeave" })

      local timer = vim.uv.new_timer()
      local group = vim.api.nvim_create_augroup("PowerModeStreakTheme", { clear = true })
      local last_activity = 0
      local theme_timeout_ms = 8000

      local function refresh_timer()
        last_activity = vim.uv.now()
        if streak > 0 and timer then
          timer:stop()
          timer:start(
            1000,
            1000,
            vim.schedule_wrap(function()
              if (vim.uv.now() - last_activity) >= theme_timeout_ms then
                streak = 0
                apply_level(0)
                timer:stop()
              end
            end)
          )
        end
      end

      vim.api.nvim_create_autocmd("InsertCharPre", {
        group = group,
        callback = function()
          streak = streak + 1
          local lvl = streak_to_level(streak)
          vim.schedule(function()
            if lvl > last_level then
              apply_level(lvl)
            end
            refresh_timer()
          end)
        end,
      })

      -- Mantém o streak e o tema vivos enquanto estiver editando/navegando no Normal mode após apertar <Esc>
      vim.api.nvim_create_autocmd({ "TextChanged", "CursorMoved" }, {
        group = group,
        callback = function()
          if streak > 0 then
            last_activity = vim.uv.now()
          end
        end,
      })
    end,
  },

  -- 🌧️ Cellular Automaton: Efeito Físico de Chuva de Código, Gravidade e Game of Life (com Toggle Inteligente)
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = function()
      local function toggle(anim)
        local ok, manager = pcall(require, "cellular-automaton.manager")
        if ok and manager then
          local _, in_prog = debug.getupvalue(manager.clean, 1)
          if in_prog then
            manager.clean()
            return
          end
        end
        require("cellular-automaton").start_animation(anim)
      end

      return {
        {
          "<leader>ur",
          function()
            toggle("make_it_rain")
          end,
          desc = "Toggle Make It Rain (Chuva de Código)",
        },
        {
          "<leader>ug",
          function()
            toggle("game_of_life")
          end,
          desc = "Toggle Game of Life (Células Vivas)",
        },
        {
          "<leader>us",
          function()
            toggle("scramble")
          end,
          desc = "Toggle Scramble (Glitch Matrix)",
        },
      }
    end,
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

