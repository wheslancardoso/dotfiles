local M = {}

local HEIGHT = 4
local PH = HEIGHT * 2 -- 8 vertical RGB sub-pixels via half-block '▀'
local TICK_MS = 33 -- ~30 FPS
local IDLE_COOL_MS = 8000
local MAX_EMBERS = 48

local HALF_BLOCK = "\226\150\128" -- U+2580 '▀' (3 UTF-8 bytes)
local EMBER_CHARS = { "·", "•", "✦" }
local EMBER_HLS = { "FireWallHDEmber1", "FireWallHDEmber2", "FireWallHDEmber3" }

-- 11 visible stops (buckets 1..11); bucket 0 is transparent (bg_hex)
local FIRE_STOPS = {
  "#420b09", -- 1: deep ember
  "#780d12", -- 2: dark crimson
  "#b51614", -- 3: crimson
  "#e32610", -- 4: red
  "#ff4800", -- 5: red-orange
  "#ff7400", -- 6: orange
  "#ffa200", -- 7: amber
  "#ffc81a", -- 8: gold
  "#ffe666", -- 9: bright gold
  "#fff4b8", -- 10: pale hot
  "#ffffff", -- 11: white-hot
}

local FIRE_ACCENT_WEIGHTS = {
  0.08,
  0.14,
  0.18,
  0.22,
  0.22,
  0.20,
  0.16,
  0.12,
  0.08,
  0.04,
  0.00,
}

local AURORA_STOPS = {
  "#1b1448", -- 1: deep indigo
  "#3b1d78", -- 2: indigo-violet
  "#6f2dbd", -- 3: violet
  "#bd28d6", -- 4: violet-magenta
  "#ff2cf1", -- 5: neon magenta
  "#7c6eff", -- 6: electric orchid-blue
  "#38bdf8", -- 7: sky blue
  "#00e5ff", -- 8: cyan-sky
  "#00f5ff", -- 9: electric cyan
  "#a5fff6", -- 10: luminous cyan-mint
  "#fff6c2", -- 11: celestial white-gold
}

local AURORA_ACCENT_WEIGHTS = {
  0.06,
  0.10,
  0.14,
  0.16,
  0.18,
  0.20,
  0.20,
  0.18,
  0.14,
  0.08,
  0.04,
}

-- Precompute 12x12 highlight group name lookup table & 0..255 bucket LUT
local HL_NAMES = {}
for t = 0, 11 do
  HL_NAMES[t] = {}
  for b = 0, 11 do
    if t == 0 and b == 0 then
      HL_NAMES[t][b] = "FireWallHDBg"
    else
      HL_NAMES[t][b] = string.format("FireWallHD_T%d_B%d", t, b)
    end
  end
end

local BUCKET_LUT = {}
for h = 0, 255 do
  if h < 12 then
    BUCKET_LUT[h] = 0
  else
    local bucket = math.floor((h * 11) / 255 + 0.5)
    BUCKET_LUT[h] = math.min(11, math.max(1, bucket))
  end
end

local ns = vim.api.nvim_create_namespace("FireWallHD")

local state = {
  buf = nil,
  win = nil,
  timer = nil,
  timer_running = false,
  grid = {},
  width = 0,
  embers = {},
  level = 0,
  streak = 0,
  is_heaven = false,
  bg_hex = "#1e1e2e",
  accent_fg = "#ff4000",
  theme_key = nil,
  palette = nil,
  hl_cache = {},
  last_ignite_ms = 0,
  cooling_down = false,
  phase = 0.0,
}

local function clamp(val, lo, hi)
  if val < lo then
    return lo
  elseif val > hi then
    return hi
  end
  return val
end

local function normalize_hex(hex, fallback)
  if type(hex) ~= "string" then
    return fallback
  end
  local clean = hex:match("^#?(%x%x%x%x%x%x)$")
  if not clean then
    return fallback
  end
  return "#" .. clean:lower()
end

local function hex_to_rgb(hex)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)
  return r, g, b
end

local function lerp_hex(c1, c2, alpha)
  local r1, g1, b1 = hex_to_rgb(c1)
  local r2, g2, b2 = hex_to_rgb(c2)
  local r = clamp(math.floor(r1 + (r2 - r1) * alpha + 0.5), 0, 255)
  local g = clamp(math.floor(g1 + (g2 - g1) * alpha + 0.5), 0, 255)
  local b = clamp(math.floor(b1 + (b2 - b1) * alpha + 0.5), 0, 255)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function build_palette(is_heaven, bg_hex, accent_fg)
  local stops = is_heaven and AURORA_STOPS or FIRE_STOPS
  local weights = is_heaven and AURORA_ACCENT_WEIGHTS or FIRE_ACCENT_WEIGHTS
  local palette = { [0] = bg_hex }

  for i = 1, 11 do
    local col = lerp_hex(stops[i], accent_fg, weights[i])
    if i == 1 then
      col = lerp_hex(col, bg_hex, 0.22)
    elseif i == 2 then
      col = lerp_hex(col, bg_hex, 0.08)
    end
    palette[i] = col
  end

  return palette
end

local function apply_theme_highlights()
  local key = (state.is_heaven and "1" or "0") .. "|" .. state.bg_hex .. "|" .. state.accent_fg
  local bg_hl = vim.api.nvim_get_hl(0, { name = "FireWallHDBg" })
  local hls_wiped = (next(bg_hl) == nil)

  if state.theme_key == key and state.palette and not hls_wiped then
    return
  end

  if hls_wiped then
    state.hl_cache = {}
  end

  local palette = build_palette(state.is_heaven, state.bg_hex, state.accent_fg)
  state.palette = palette
  state.theme_key = key

  vim.api.nvim_set_hl(0, "FireWallHDBg", { bg = state.bg_hex, fg = state.bg_hex })
  vim.api.nvim_set_hl(0, "FireWallHDEmber1", { fg = palette[4], bg = state.bg_hex })
  vim.api.nvim_set_hl(0, "FireWallHDEmber2", { fg = palette[7], bg = state.bg_hex })
  vim.api.nvim_set_hl(0, "FireWallHDEmber3", { fg = palette[10], bg = state.bg_hex, bold = true })

  for t = 0, 11 do
    local fg = palette[t]
    for b = 0, 11 do
      if t > 0 or b > 0 then
        local bg = palette[b]
        local name = HL_NAMES[t][b]
        local pair_sig = fg .. bg
        if state.hl_cache[name] ~= pair_sig then
          vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg })
          state.hl_cache[name] = pair_sig
        end
      end
    end
  end
end

local function update_theme_state(is_heaven, bg_hex, accent_fg, level)
  local prev_heaven = state.is_heaven
  if is_heaven ~= nil then
    state.is_heaven = is_heaven and true or false
  end
  if bg_hex ~= nil then
    state.bg_hex = normalize_hex(bg_hex, state.bg_hex)
  end
  if accent_fg ~= nil then
    state.accent_fg = normalize_hex(accent_fg, state.accent_fg)
  elseif is_heaven ~= nil and state.is_heaven ~= prev_heaven then
    state.accent_fg = state.is_heaven and "#00f5ff" or "#ff4000"
  end
  if level ~= nil then
    state.level = clamp(math.floor(tonumber(level) or 0), 0, 10)
  end
  apply_theme_highlights()
end

local function ensure_grid(width)
  if state.width == width and #state.grid == PH then
    return
  end

  local new_grid = {}
  for y = 1, PH do
    local old_row = state.grid[y]
    local row = {}
    for x = 1, width do
      row[x] = (old_row and old_row[x]) or 0
    end
    new_grid[y] = row
  end

  state.grid = new_grid
  state.width = width
end

local function push_cursor_above_flames(row)
  local cur_win = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(cur_win) or cur_win == state.win then
    return
  end

  local win_cfg = vim.api.nvim_win_get_config(cur_win)
  if win_cfg.relative and win_cfg.relative ~= "" then
    return
  end

  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  if not vim.api.nvim_buf_is_valid(cur_buf) or vim.bo[cur_buf].buftype ~= "" then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(cur_win)
  local ok_sp, sp = pcall(vim.fn.screenpos, cur_win, cursor[1], cursor[2] + 1)
  if ok_sp and sp and sp.row > 0 and sp.row >= row then
    local push = (sp.row - row) + 2
    local view = vim.api.nvim_win_call(cur_win, vim.fn.winsaveview)
    local line_count = vim.api.nvim_buf_line_count(cur_buf)
    local new_top = math.min(line_count, view.topline + push)
    if new_top > view.topline then
      vim.api.nvim_win_call(cur_win, function()
        vim.fn.winrestview({ topline = new_top })
      end)
    end
  end
end

local function render()
  local width = math.max(1, vim.o.columns)
  ensure_grid(width)

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  -- Map active rising embers onto cell coordinates (0-indexed row, 1-indexed col)
  local ember_cells = {}
  for _, em in ipairs(state.embers) do
    local cx = clamp(math.floor(em.x + 0.5), 1, width)
    local cy = clamp(math.floor((em.y - 1) * 0.5), 0, HEIGHT - 1)
    local tier = (em.ttl > 12 and em.max_tier >= 3) and 3 or ((em.ttl > 6 and em.max_tier >= 2) and 2 or 1)
    local row_map = ember_cells[cy]
    if not row_map then
      row_map = {}
      ember_cells[cy] = row_map
    end
    if not row_map[cx] or tier > row_map[cx] then
      row_map[cx] = tier
    end
  end

  local lines = {}
  local row_spans = {}
  local grid = state.grid

  for cy = 0, HEIGHT - 1 do
    local top_row = grid[cy * 2 + 1]
    local bot_row = grid[cy * 2 + 2]
    local row_embers = ember_cells[cy]

    local chars = {}
    local spans = {}
    local byte_pos = 0
    local run_hl = nil
    local run_start = 0

    for cx = 1, width do
      local t = BUCKET_LUT[clamp(math.floor(top_row[cx] + 0.5), 0, 255)]
      local b = BUCKET_LUT[clamp(math.floor(bot_row[cx] + 0.5), 0, 255)]
      local ch
      local hl

      if t == 0 and b == 0 then
        local em_tier = row_embers and row_embers[cx]
        if em_tier then
          ch = EMBER_CHARS[em_tier]
          hl = EMBER_HLS[em_tier]
        else
          ch = " "
          hl = "FireWallHDBg"
        end
      else
        ch = HALF_BLOCK
        hl = HL_NAMES[t][b]
      end

      chars[cx] = ch

      if hl ~= run_hl then
        if run_hl then
          spans[#spans + 1] = { run_start, byte_pos, run_hl }
        end
        run_hl = hl
        run_start = byte_pos
      end
      byte_pos = byte_pos + #ch
    end

    if run_hl then
      spans[#spans + 1] = { run_start, byte_pos, run_hl }
    end

    lines[cy + 1] = table.concat(chars)
    row_spans[cy + 1] = spans
  end

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)

  for row_idx = 1, HEIGHT do
    local spans = row_spans[row_idx]
    local line_idx = row_idx - 1
    for i = 1, #spans do
      local sp = spans[i]
      vim.api.nvim_buf_set_extmark(state.buf, ns, line_idx, sp[1], {
        end_col = sp[2],
        hl_group = sp[3],
      })
    end
  end

  local row = math.max(0, vim.o.lines - 6)
  push_cursor_above_flames(row)

  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    state.win = vim.api.nvim_open_win(state.buf, false, {
      relative = "editor",
      row = row,
      col = 0,
      width = width,
      height = HEIGHT,
      style = "minimal",
      focusable = false,
      zindex = 40,
      noautocmd = true,
    })
    pcall(vim.api.nvim_set_option_value, "winhighlight", "Normal:FireWallHDBg", { win = state.win })
    pcall(vim.api.nvim_set_option_value, "winblend", 22, { win = state.win })
  else
    pcall(vim.api.nvim_win_set_config, state.win, {
      relative = "editor",
      row = row,
      col = 0,
      width = width,
      height = HEIGHT,
    })
  end
end

local function spawn_ember(x, y, max_tier, vx_scale, force)
  if #state.embers >= MAX_EMBERS then
    if not force then
      return
    end
    table.remove(state.embers, 1)
  end
  state.embers[#state.embers + 1] = {
    x = x,
    y = y,
    vx = (math.random() - 0.5) * (vx_scale or 0.85),
    vy = -(0.32 + math.random() * 0.38),
    ttl = math.random(12, 24),
    max_tier = max_tier or 2,
  }
end

local function on_tick()
  if not state.timer_running then
    return
  end

  local width = math.max(1, vim.o.columns)
  ensure_grid(width)

  local grid = state.grid
  local lvl = state.level
  local idle_ms = vim.uv.now() - state.last_ignite_ms
  local seeding = (not state.cooling_down) and (lvl > 0) and (idle_ms < IDLE_COOL_MS)

  state.phase = state.phase + 0.14
  local sway_amp = state.is_heaven and 0.85 or 0.50

  -- Turbulent cooling decreases as level increases (0..10)
  local min_cool = math.max(2, math.floor(14 - lvl * 1.2))
  local max_cool = math.max(min_cool + 6, math.floor(44 - lvl * 2.7))
  if not seeding then
    min_cool = math.max(min_cool, 6)
  end

  -- Doom/PSX upward cellular fire propagation (y = 1..PH-1 pull from y+1)
  for y = 1, PH - 1 do
    local dst = grid[y]
    local src = grid[y + 1]
    local sway = math.sin(state.phase + y * 0.35) * sway_amp
    for x = 1, width do
      local jitter = (math.random() - 0.5) * 1.8
      local sx = clamp(math.floor(x + sway + jitter + 0.5), 1, width)
      local lx = sx > 1 and (sx - 1) or sx
      local rx = sx < width and (sx + 1) or sx
      local heat = src[sx] * 0.80 + (src[lx] + src[rx]) * 0.10
      local cooled = heat - math.random(min_cool, max_cool)
      dst[x] = cooled > 0 and cooled or 0
    end
  end

  -- Bottom source row (y = PH): simmer while active & level > 0; decay cleanly during cooldown
  local base_row = grid[PH]
  local any_heat = false
  local phase = state.phase

  for x = 1, width do
    local h = base_row[x]
    if seeding then
      h = math.max(0, h - math.random(8, 16))
      local wave = clamp(
        0.45 + 0.35 * math.sin(x * 0.14 + phase * 0.9) + 0.25 * math.sin(x * 0.31 - phase * 1.4),
        0.12,
        1.05
      )
      local simmer = math.floor((75 + lvl * 15) * wave + math.random(0, 35 + lvl * 3))
      if simmer > h then
        h = simmer
      end
      if h > 255 then
        h = 255
      end
    else
      h = math.max(0, h - math.random(18, 34))
    end
    base_row[x] = h
    if h >= 12 then
      any_heat = true
    end
  end

  if not any_heat then
    for y = 1, PH - 1 do
      local row = grid[y]
      for x = 1, width do
        if row[x] >= 12 then
          any_heat = true
          break
        end
      end
      if any_heat then
        break
      end
    end
  end

  -- Advance rising embers
  local global_sway = math.sin(state.phase) * sway_amp
  local next_embers = {}
  for i = 1, #state.embers do
    local em = state.embers[i]
    em.ttl = em.ttl - 1
    em.x = em.x + em.vx + global_sway * 0.20
    em.y = em.y + em.vy
    if em.ttl > 0 and em.y >= 0.5 and em.x >= 1 and em.x <= width then
      next_embers[#next_embers + 1] = em
    end
  end
  state.embers = next_embers

  -- Spawn ambient base embers scaling with level while actively simmering
  if seeding and math.random() < (0.20 + lvl * 0.08) then
    local ambient_count = (lvl >= 6 and math.random(1, 2)) or 1
    for _ = 1, ambient_count do
      local ex = math.random(1, width)
      local ey = PH - 1.5 - math.random() * 2.5
      local tier = (lvl >= 5 and math.random(2, 3)) or math.random(1, 2)
      spawn_ember(ex, ey, tier, 0.70, false)
    end
  end

  if (not seeding) and (not any_heat) and (#state.embers == 0) then
    M.close()
    return
  end

  render()
end

local function ensure_timer()
  if not state.timer then
    state.timer = vim.uv.new_timer()
  end
  if state.timer and not state.timer_running then
    state.timer_running = true
    state.timer:start(TICK_MS, TICK_MS, vim.schedule_wrap(on_tick))
  end
end

function M.set_theme(is_heaven, bg_hex, accent_fg, level)
  update_theme_state(is_heaven, bg_hex, accent_fg, level)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    render()
  end
end

function M.ignite(level, streak, is_heaven, bg_hex, accent_fg)
  update_theme_state(is_heaven, bg_hex, accent_fg, level)
  if streak ~= nil then
    state.streak = tonumber(streak) or state.streak
  end

  state.cooling_down = false
  state.last_ignite_ms = vim.uv.now()

  local width = math.max(1, vim.o.columns)
  ensure_grid(width)

  -- Query screen column of cursor for concentrated heat burst
  local cx = math.floor(width * 0.5)
  local cur_win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_is_valid(cur_win) and cur_win ~= state.win then
    local cursor = vim.api.nvim_win_get_cursor(cur_win)
    local ok_sp, sp = pcall(vim.fn.screenpos, cur_win, cursor[1], cursor[2] + 1)
    if ok_sp and sp and sp.col and sp.col > 0 then
      cx = clamp(sp.col, 1, width)
    else
      cx = clamp(cursor[2] + 1, 1, width)
    end
  end

  -- White-hot Gaussian heat burst (radius = 6..12 scaling with level 0..10)
  local lvl = state.level
  local radius = 6 + math.floor(lvl * 0.6)
  local sigma = radius * 0.48
  local inv_two_sigma2 = 1.0 / (2.0 * sigma * sigma)
  local grid = state.grid

  for dx = -radius, radius do
    local x = cx + dx
    if x >= 1 and x <= width then
      local falloff = math.exp(-(dx * dx) * inv_two_sigma2)
      local h8 = math.floor(255 * falloff + 0.5)
      local h7 = math.floor(245 * falloff + 0.5)
      if h8 > grid[PH][x] then
        grid[PH][x] = h8
      end
      if h7 > grid[PH - 1][x] then
        grid[PH - 1][x] = h7
      end
      if PH >= 3 and falloff > 0.45 then
        local h6 = math.floor(220 * falloff + 0.5)
        if h6 > grid[PH - 2][x] then
          grid[PH - 2][x] = h6
        end
      end
    end
  end

  -- Spawn 2-4 rising embers at the ignition plume
  local burst_embers = math.random(2, 4)
  for _ = 1, burst_embers do
    local ex = clamp(cx + (math.random() - 0.5) * radius * 1.1, 1, width)
    local ey = PH - 2.0 - math.random() * 2.5
    local max_tier = (lvl >= 3 or state.is_heaven) and 3 or math.random(2, 3)
    spawn_ember(ex, ey, max_tier, 1.0, true)
  end

  render()
  ensure_timer()
end

function M.cool_down()
  state.cooling_down = true
end

function M.close()
  if state.timer and state.timer_running then
    state.timer:stop()
    state.timer_running = false
  end
  state.cooling_down = false
  state.embers = {}
  for y = 1, #state.grid do
    local row = state.grid[y]
    for x = 1, #row do
      row[x] = 0
    end
  end
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  state.win = nil
end

return M
