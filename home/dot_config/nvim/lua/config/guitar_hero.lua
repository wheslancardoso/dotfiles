local M = {}

local bit = bit or bit32

local HEIGHT = 6
local PH = HEIGHT * 4 -- 24 vertical sub-pixels
local TICK_MS = 33
local IDLE_CLOSE_MS = 8000
local HIT_Y = 21.5
local Z_FAR = 3.2
local Z_NEAR = 0.65
local INV_FAR = 1.0 / Z_FAR
local INV_NEAR = 1.0 / Z_NEAR
local STAR_COUNT = 24

local FIRE_LANES = {
  "#39ff14", -- Green
  "#ff4000", -- Red
  "#ffd700", -- Yellow
  "#00f5ff", -- Cyan
  "#ff8800", -- Orange
}

local HEAVEN_LANES = {
  "#00ffaa", -- Neon Mint
  "#ff55cc", -- Neon Magenta
  "#fff066", -- Celestial Gold
  "#00f5ff", -- Electric Cyan
  "#a855f7", -- Neon Violet
}

local LANE_U = { -0.8, -0.4, 0.0, 0.4, 0.8 }
local DIVIDER_U = { -0.6, -0.2, 0.2, 0.6 }

local BRAILLE_BIT = {
  { 0x01, 0x08 },
  { 0x02, 0x10 },
  { 0x04, 0x20 },
  { 0x40, 0x80 },
}

local QWERTY_MAP = {}
do
  local groups = {
    { "1", "q", "a", "z", "2", "w", "s", "x", "!", "@", "~", "`" },
    { "3", "e", "d", "c", "4", "r", "f", "v", "#", "$" },
    { "5", "t", "g", "b", "6", "y", "h", "n", "%", "^" },
    { "7", "u", "j", "m", "8", "i", "k", ",", "&", "*", "<" },
    { "9", "o", "l", ".", "0", "p", ";", "/", "-", "=", "[", "]", "'", "\\", "(", ")", "_", "+", "{", "}", ":", "\"", "?", ">" },
  }
  for lane, keys in ipairs(groups) do
    for _, k in ipairs(keys) do
      QWERTY_MAP[k] = lane
    end
  end
end

local PRIO_DECK = 0
local PRIO_STAR = 1
local PRIO_FRET = 2
local PRIO_RAIL = 3
local PRIO_TARGET = 4
local PRIO_LASER = 5
local PRIO_TRAIL = 6
local PRIO_NOTE_DIM = 7
local PRIO_NOTE = 8
local PRIO_NOTE_CORE = 9
local PRIO_SPARK = 10

local ns = vim.api.nvim_create_namespace("GuitarHeroHighway")

local state = {
  buf = nil,
  win = nil,
  timer = nil,
  timer_running = false,
  notes = {},
  sparks = {},
  stars = {},
  lightnings = {},
  target_flash = {},
  laser_flash = {},
  recent_hits = {},
  fret_phase = 0.0,
  last_hit_ms = 0,
  last_lane = nil,
  is_heaven = false,
  bg_hex = "#1e1e2e",
  rail_fg = "#7f849c",
  level = 0,
  streak = 0,
  tick_count = 0,
}

local function parse_hex(hex)
  if type(hex) ~= "string" then
    return 30, 30, 46
  end
  local h = hex:gsub("^#", "")
  if #h ~= 6 then
    return 30, 30, 46
  end
  local r = tonumber(h:sub(1, 2), 16) or 30
  local g = tonumber(h:sub(3, 4), 16) or 30
  local b = tonumber(h:sub(5, 6), 16) or 46
  return r, g, b
end

local function lerp_hex(hex1, hex2, t)
  local r1, g1, b1 = parse_hex(hex1)
  local r2, g2, b2 = parse_hex(hex2)
  local r = math.floor(r1 + (r2 - r1) * t + 0.5)
  local g = math.floor(g1 + (g2 - g1) * t + 0.5)
  local b = math.floor(b1 + (b2 - b1) * t + 0.5)
  return string.format("#%02x%02x%02x", math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b)))
end

local function mask_to_utf8(mask)
  if mask == 0 then
    return " "
  end
  local b2 = 0xA0 + bit.rshift(mask, 6)
  local b3 = 0x80 + bit.band(mask, 0x3F)
  return string.char(0xE2, b2, b3)
end

local function apply_highlights()
  local palette = state.is_heaven and HEAVEN_LANES or FIRE_LANES
  local deck_bg = lerp_hex(state.bg_hex, "#000000", 0.42)
  local star_power_fg = state.is_heaven and "#ffd700" or "#00f5ff"

  vim.api.nvim_set_hl(0, "GuitarHeroBg", { bg = state.bg_hex })
  vim.api.nvim_set_hl(0, "GuitarHeroDeck", { bg = deck_bg })
  vim.api.nvim_set_hl(0, "GuitarHeroRail", { fg = state.rail_fg, bg = deck_bg, bold = true })
  vim.api.nvim_set_hl(0, "GuitarHeroStarPower", { fg = star_power_fg, bg = deck_bg, bold = true })
  vim.api.nvim_set_hl(0, "GuitarHeroFret", { fg = lerp_hex(state.rail_fg, deck_bg, 0.35), bg = deck_bg })
  vim.api.nvim_set_hl(0, "GuitarHeroStar", {
    fg = state.is_heaven and "#7dd3fc" or "#fab387",
    bg = state.bg_hex,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroHitBar", {
    fg = state.is_heaven and "#e0f2fe" or "#f5e0dc",
    bg = deck_bg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroOpen", {
    fg = state.is_heaven and "#ffd700" or "#c084fc",
    bg = deck_bg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroOpenCore", {
    fg = "#ffffff",
    bg = deck_bg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroLightning", {
    fg = state.is_heaven and "#fef08a" or "#e0f2fe",
    bg = deck_bg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroHudLeft", {
    fg = state.is_heaven and "#00f5ff" or "#ffd700",
    bg = state.bg_hex,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroHudRight", {
    fg = state.is_heaven and "#ff55cc" or "#39ff14",
    bg = state.bg_hex,
    bold = true,
  })

  for i = 1, 5 do
    vim.api.nvim_set_hl(0, "GuitarHeroLane" .. i .. "Core", {
      fg = lerp_hex(palette[i], "#ffffff", 0.72),
      bg = deck_bg,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "GuitarHeroLane" .. i, {
      fg = palette[i],
      bg = deck_bg,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "GuitarHeroLane" .. i .. "Dim", {
      fg = lerp_hex(palette[i], state.bg_hex, 0.55),
      bg = deck_bg,
    })
    vim.api.nvim_set_hl(0, "GuitarHeroSpark" .. i, {
      fg = palette[i],
      bg = state.bg_hex,
      bold = true,
    })
  end
end

local function canvas_dims()
  local width = math.min(vim.o.columns, math.max(56, math.floor(vim.o.columns * 0.88)))
  return width, width * 2
end

local function depth_to_t(z)
  local t = ((1.0 / math.max(Z_NEAR, math.min(Z_FAR, z))) - INV_FAR) / (INV_NEAR - INV_FAR)
  return math.max(0.0, math.min(1.0, t))
end

local function project_x(u, y, pw)
  local center_x = (pw - 1) * 0.5
  local top_half_w = pw * 0.14
  local bot_half_w = pw * 0.35
  local t = math.max(0, math.min(1, y / (PH - 1)))
  local half_w = top_half_w + (bot_half_w - top_half_w) * t
  return center_x + u * half_w
end

local function spawn_star(pw, random_y)
  local side = (math.random(2) == 1) and -1 or 1
  local y = random_y and (math.random() * (PH - 2)) or (math.random() * 2.5)
  local edge_x = project_x(side, y, pw)
  local margin = 4 + math.random() * math.max(8, pw * 0.15)
  return {
    x = edge_x + side * margin,
    y = y,
    vx = side * (0.9 + math.random() * 1.4),
    vy = 0.6 + math.random() * 0.9,
  }
end

local function ensure_stars(pw)
  while #state.stars < STAR_COUNT do
    state.stars[#state.stars + 1] = spawn_star(pw, true)
  end
end

local function auto_scroll_editor(widget_row)
  local cur_win = vim.api.nvim_get_current_win()
  if state.win and cur_win == state.win then
    return
  end
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  if not vim.api.nvim_buf_is_valid(cur_buf) or vim.bo[cur_buf].buftype ~= "" then
    return
  end
  local cursor = vim.api.nvim_win_get_cursor(cur_win)
  local sp = vim.fn.screenpos(cur_win, cursor[1], cursor[2] + 1)
  if sp and sp.row and sp.row >= widget_row then
    local view = vim.fn.winsaveview()
    local line_count = vim.api.nvim_buf_line_count(cur_buf)
    local shift = (sp.row - widget_row) + 2
    vim.fn.winrestview({ topline = math.min(line_count, view.topline + shift) })
  end
end

local function multiplier_badge(level)
  if level >= 8 then
    return "★ MAX"
  elseif level >= 6 then
    return "x4"
  elseif level >= 4 then
    return "x3"
  elseif level >= 2 then
    return "x2"
  end
  return "x1"
end

local function compute_wpm()
  local now = vim.uv.now()
  local kept = {}
  for _, ts in ipairs(state.recent_hits) do
    if now - ts <= 4000 then
      kept[#kept + 1] = ts
    end
  end
  state.recent_hits = kept
  return math.floor(#kept * 3)
end

local function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  local width, pw = canvas_dims()
  ensure_stars(pw)

  local total_cells = width * HEIGHT
  local masks = {}
  local prios = {}
  local hls = {}

  for cy = 0, HEIGHT - 1 do
    local py_mid = cy * 4 + 1.5
    local lx = project_x(-1.0, py_mid, pw)
    local rx = project_x(1.0, py_mid, pw)
    for cx = 0, width - 1 do
      local idx = cy * width + cx + 1
      local px_mid = cx * 2 + 0.5
      masks[idx] = 0
      prios[idx] = PRIO_DECK
      if px_mid >= lx - 0.5 and px_mid <= rx + 0.5 then
        hls[idx] = "GuitarHeroDeck"
      else
        hls[idx] = nil
      end
    end
  end

  local function plot(fx, fy, hl, prio)
    local px = math.floor(fx + 0.5)
    local py = math.floor(fy + 0.5)
    if px < 0 or px >= pw or py < 0 or py >= PH then
      return
    end
    local cx = math.floor(px / 2)
    local cy = math.floor(py / 4)
    local dx = px % 2
    local dy = py % 4
    local idx = cy * width + cx + 1
    masks[idx] = bit.bor(masks[idx], BRAILLE_BIT[dy + 1][dx + 1])
    if prio >= prios[idx] then
      prios[idx] = prio
      hls[idx] = hl
    end
  end

  local function draw_hline(x0, x1, y, hl, prio)
    local sx = math.floor(math.min(x0, x1) + 0.5)
    local ex = math.floor(math.max(x0, x1) + 0.5)
    for px = sx, ex do
      plot(px, y, hl, prio)
    end
  end

  -- 1. Outer starfield & speed lasers outside the 3D trapezoid
  for _, st in ipairs(state.stars) do
    local lx = project_x(-1.0, st.y, pw)
    local rx = project_x(1.0, st.y, pw)
    if st.x < lx - 1 or st.x > rx + 1 then
      plot(st.x, st.y, "GuitarHeroStar", PRIO_STAR)
      plot(st.x - st.vx * 0.55, st.y - st.vy * 0.55, "GuitarHeroStar", PRIO_STAR)
      plot(st.x - st.vx * 1.1, st.y - st.vy * 1.1, "GuitarHeroStar", PRIO_STAR)
    end
  end

  -- 2. True 1/z scrolling 3D perspective fret bars (6 bars evenly spaced in z)
  local z_span = Z_FAR - Z_NEAR
  local z_step = z_span / 6.0
  for k = 0, 5 do
    local fz = Z_FAR - ((k * z_step + state.fret_phase) % z_span)
    local fy = depth_to_t(fz) * HIT_Y
    local lx = project_x(-1.0, fy, pw)
    local rx = project_x(1.0, fy, pw)
    local sx = math.floor(lx + 0.5)
    local ex = math.floor(rx + 0.5)
    for px = sx, ex, 2 do
      plot(px, fy, "GuitarHeroFret", PRIO_FRET)
    end
  end

  -- 3. Double-pixel perspective outer rails (Star Power pulse when level >= 3 or is_heaven)
  local star_power = state.is_heaven or (state.level >= 3)
  local rail_hl = (star_power and (state.tick_count % 6 < 4)) and "GuitarHeroStarPower" or "GuitarHeroRail"
  for py = 0, PH - 1 do
    local lx = project_x(-1.0, py, pw)
    local rx = project_x(1.0, py, pw)
    plot(lx, py, rail_hl, PRIO_RAIL)
    plot(lx + 1, py, rail_hl, PRIO_RAIL)
    plot(rx - 1, py, rail_hl, PRIO_RAIL)
    plot(rx, py, rail_hl, PRIO_RAIL)
    for _, du in ipairs(DIVIDER_U) do
      if py % 2 == 0 or py >= 18 then
        plot(project_x(du, py, pw), py, "GuitarHeroRail", PRIO_RAIL)
      end
    end
  end

  -- 4. Vertical laser/flame columns on impact
  for lane, ticks in pairs(state.laser_flash) do
    if ticks > 0 then
      local lane_hl = "GuitarHeroLane" .. lane
      local core_hl = lane_hl .. "Core"
      local u = LANE_U[lane]
      for py = 0, HIT_Y do
        local cx = project_x(u, py, pw)
        plot(cx, py, core_hl, PRIO_LASER)
        if py >= 8 then
          plot(cx - 1, py, lane_hl, PRIO_LASER)
          plot(cx + 1, py, lane_hl, PRIO_LASER)
        end
      end
    end
  end

  -- 5. Glowing hit-bar at y = 21.5 and 5 pulsing circular fret targets
  local bar_lx = project_x(-1.0, HIT_Y, pw)
  local bar_rx = project_x(1.0, HIT_Y, pw)
  draw_hline(bar_lx, bar_rx, HIT_Y, "GuitarHeroHitBar", PRIO_TARGET)

  for lane = 1, 5 do
    local tx = project_x(LANE_U[lane], HIT_Y, pw)
    local lane_hl = "GuitarHeroLane" .. lane
    local core_hl = lane_hl .. "Core"
    local flash_ticks = state.target_flash[lane] or 0

    for dx = -1, 1 do
      plot(tx + dx, HIT_Y - 1, lane_hl, PRIO_TARGET)
      plot(tx + dx, HIT_Y + 1, lane_hl, PRIO_TARGET)
    end
    plot(tx - 2, HIT_Y, lane_hl, PRIO_TARGET)
    plot(tx + 2, HIT_Y, lane_hl, PRIO_TARGET)

    if flash_ticks > 0 then
      for dx = -1, 1 do
        plot(tx + dx, HIT_Y, core_hl, PRIO_SPARK)
      end
      plot(tx - 3, HIT_Y, lane_hl, PRIO_SPARK)
      plot(tx + 3, HIT_Y, lane_hl, PRIO_SPARK)
      plot(tx - 2, HIT_Y - 1, lane_hl, PRIO_SPARK)
      plot(tx + 2, HIT_Y - 1, lane_hl, PRIO_SPARK)
      plot(tx - 2, HIT_Y + 1, lane_hl, PRIO_SPARK)
      plot(tx + 2, HIT_Y + 1, lane_hl, PRIO_SPARK)
    end
  end

  -- 6. 1/z perspective notes (1x1 -> 3x2 -> 7x3 3D gem + open strum bar + trails)
  for _, note in ipairs(state.notes) do
    local t = depth_to_t(note.z)
    local sy = t * HIT_Y
    local scale = Z_NEAR / note.z

    if note.open then
      local ox0 = project_x(-0.95, sy, pw)
      local ox1 = project_x(0.95, sy, pw)
      draw_hline(ox0, ox1, sy, "GuitarHeroOpenCore", PRIO_NOTE_CORE)
      if scale >= 0.45 then
        draw_hline(ox0 + 1, ox1 - 1, sy - 1, "GuitarHeroOpen", PRIO_NOTE)
      end
    else
      local lane = note.lane
      local lane_hl = "GuitarHeroLane" .. lane
      local core_hl = lane_hl .. "Core"
      local dim_hl = lane_hl .. "Dim"
      local u = LANE_U[lane]

      -- Tapered comet trail
      local trail_steps = scale >= 0.55 and 5 or 3
      for step = 1, trail_steps do
        local ty = sy - step * (0.75 + scale * 0.45)
        if ty >= 0 then
          local tx = project_x(u, ty, pw)
          plot(tx, ty, dim_hl, PRIO_TRAIL)
          if step <= 2 and scale >= 0.55 then
            plot(tx - 1, ty, dim_hl, PRIO_TRAIL)
            plot(tx + 1, ty, dim_hl, PRIO_TRAIL)
          end
        end
      end

      local nx = project_x(u, sy, pw)
      if scale < 0.36 then
        plot(nx, sy, core_hl, PRIO_NOTE_CORE)
      elseif scale < 0.62 then
        for dx = -1, 1 do
          plot(nx + dx, sy, lane_hl, PRIO_NOTE)
          plot(nx + dx, sy + 1, lane_hl, PRIO_NOTE)
        end
        plot(nx, sy, core_hl, PRIO_NOTE_CORE)
      else
        -- 7x3 glowing 3D gem with white-hot core
        for dx = -3, 3 do
          plot(nx + dx, sy, (math.abs(dx) == 3) and dim_hl or lane_hl, (math.abs(dx) == 3) and PRIO_NOTE_DIM or PRIO_NOTE)
        end
        for dx = -2, 2 do
          local hl = (math.abs(dx) == 2) and dim_hl or lane_hl
          local pr = (math.abs(dx) == 2) and PRIO_NOTE_DIM or PRIO_NOTE
          plot(nx + dx, sy - 1, hl, pr)
          plot(nx + dx, sy + 1, hl, pr)
        end
        for dx = -1, 1 do
          plot(nx + dx, sy, core_hl, PRIO_NOTE_CORE)
        end
      end
    end
  end

  -- 7. Chord / rapid-burst lightning arcs
  for _, arc in ipairs(state.lightnings) do
    local x1 = project_x(LANE_U[arc.lane_a], arc.y, pw)
    local x2 = project_x(LANE_U[arc.lane_b], arc.y, pw)
    local sx = math.floor(math.min(x1, x2) + 0.5)
    local ex = math.floor(math.max(x1, x2) + 0.5)
    for px = sx, ex do
      local jitter = ((px + state.tick_count) % 3) - 1
      plot(px, arc.y + jitter, "GuitarHeroLightning", PRIO_SPARK)
    end
  end

  -- 8. Braille spark explosions
  for _, sp in ipairs(state.sparks) do
    plot(sp.x, sp.y, "GuitarHeroSpark" .. sp.lane, PRIO_SPARK)
    if sp.ttl > 5 then
      plot(sp.x - sp.vx * 0.45, sp.y - sp.vy * 0.45, "GuitarHeroSpark" .. sp.lane, PRIO_SPARK)
    end
  end

  -- Build per-cell characters & highlights so Row 0 HUD can overlay safely
  local row_chars = {}
  local row_hls = {}
  for cy = 0, HEIGHT - 1 do
    local chars = {}
    local cell_hls = {}
    for cx = 0, width - 1 do
      local idx = cy * width + cx + 1
      chars[cx + 1] = mask_to_utf8(masks[idx])
      cell_hls[cx + 1] = hls[idx]
    end
    row_chars[cy + 1] = chars
    row_hls[cy + 1] = cell_hls
  end

  -- 9. Live Arcade HUD in Row 0 outer wings (when width >= 68)
  if width >= 68 then
    local left_wing_end = math.floor(project_x(-1.0, 0, pw) / 2) - 1
    local right_wing_start = math.ceil(project_x(1.0, 0, pw) / 2) + 1

    local left_text = " " .. multiplier_badge(state.level)
    local l_chars = vim.fn.split(left_text, "\\zs")
    if #l_chars <= left_wing_end then
      for i, ch in ipairs(l_chars) do
        local idx = i -- cy=0, cx=i-1
        if masks[idx] == 0 then
          row_chars[1][i] = ch
          row_hls[1][i] = "GuitarHeroHudLeft"
        end
      end
    end

    local wpm = compute_wpm()
    local status_tag = state.is_heaven and "★ HEAVEN" or (state.level >= 3 and "★ STAR POWER" or "")
    local right_text = (status_tag ~= "" and (wpm .. " WPM  " .. status_tag .. " ") or (wpm .. " WPM "))
    local r_chars = vim.fn.split(right_text, "\\zs")
    local r_start_cx = width - #r_chars
    if r_start_cx >= right_wing_start then
      for i, ch in ipairs(r_chars) do
        local cx = r_start_cx + i - 1
        local idx = cx + 1 -- cy=0
        if masks[idx] == 0 then
          row_chars[1][cx + 1] = ch
          row_hls[1][cx + 1] = "GuitarHeroHudRight"
        end
      end
    end
  end

  -- Build lines & UTF-8 byte-offset RLE extmark spans
  local lines = {}
  local row_spans = {}
  for cy = 1, HEIGHT do
    local chars = row_chars[cy]
    local cell_hls = row_hls[cy]
    local spans = {}
    local byte_pos = 0
    local run_hl = nil
    local run_start = 0

    for cx = 1, width do
      local ch = chars[cx]
      local hl = cell_hls[cx]
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

    lines[cy] = table.concat(chars)
    row_spans[cy] = spans
  end

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)

  for row_idx, spans in ipairs(row_spans) do
    for _, sp in ipairs(spans) do
      vim.api.nvim_buf_set_extmark(state.buf, ns, row_idx - 1, sp[1], {
        end_col = sp[2],
        hl_group = sp[3],
      })
    end
  end

  local row = math.max(0, vim.o.lines - 8)
  local col = math.max(0, math.floor((vim.o.columns - width) / 2))
  auto_scroll_editor(row)

  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    state.win = vim.api.nvim_open_win(state.buf, false, {
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = HEIGHT,
      style = "minimal",
      focusable = false,
      zindex = 45,
      noautocmd = true,
    })
    pcall(vim.api.nvim_win_set_option, state.win, "winhighlight", "Normal:GuitarHeroBg")
    pcall(vim.api.nvim_win_set_option, state.win, "winblend", 12)
  else
    pcall(vim.api.nvim_win_set_config, state.win, {
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = HEIGHT,
    })
  end
end

local function spawn_impact(lane)
  local _, pw = canvas_dims()
  local cx = project_x(LANE_U[lane], HIT_Y, pw)
  local count = 12
  for i = 1, count do
    local spread = (i - (count + 1) * 0.5) * 0.36 + (math.random() - 0.5) * 0.3
    state.sparks[#state.sparks + 1] = {
      x = cx + (math.random() - 0.5) * 2.0,
      y = HIT_Y - 0.5,
      vx = spread,
      vy = -(0.85 + math.random() * 1.45),
      lane = lane,
      ttl = math.random(9, 14),
    }
  end
  state.target_flash[lane] = 6
  state.laser_flash[lane] = 5
end

local function on_tick()
  local _, pw = canvas_dims()
  state.tick_count = state.tick_count + 1
  local dz = 0.105 + math.min(state.level or 0, 10) * 0.004
  state.fret_phase = (state.fret_phase + dz) % (Z_FAR - Z_NEAR)

  for i, st in ipairs(state.stars) do
    st.x = st.x + st.vx
    st.y = st.y + st.vy
    if st.x < 0 or st.x >= pw or st.y >= PH then
      state.stars[i] = spawn_star(pw, false)
    end
  end

  local next_notes = {}
  for _, note in ipairs(state.notes) do
    local next_z = note.z - dz
    if next_z <= Z_NEAR then
      if note.open then
        for l = 1, 5 do
          spawn_impact(l)
        end
      else
        spawn_impact(note.lane)
      end
    else
      note.z = next_z
      next_notes[#next_notes + 1] = note
    end
  end
  state.notes = next_notes

  local next_sparks = {}
  for _, sp in ipairs(state.sparks) do
    sp.ttl = sp.ttl - 1
    if sp.ttl > 0 then
      sp.x = sp.x + sp.vx
      sp.y = sp.y + sp.vy
      sp.vy = sp.vy + 0.17
      next_sparks[#next_sparks + 1] = sp
    end
  end
  state.sparks = next_sparks

  local next_arcs = {}
  for _, arc in ipairs(state.lightnings) do
    arc.ttl = arc.ttl - 1
    if arc.ttl > 0 then
      next_arcs[#next_arcs + 1] = arc
    end
  end
  state.lightnings = next_arcs

  for lane, ticks in pairs(state.target_flash) do
    if ticks <= 1 then
      state.target_flash[lane] = nil
    else
      state.target_flash[lane] = ticks - 1
    end
  end

  for lane, ticks in pairs(state.laser_flash) do
    if ticks <= 1 then
      state.laser_flash[lane] = nil
    else
      state.laser_flash[lane] = ticks - 1
    end
  end

  local idle_ms = vim.uv.now() - state.last_hit_ms
  if
    #state.notes == 0
    and #state.sparks == 0
    and #state.lightnings == 0
    and next(state.target_flash) == nil
    and next(state.laser_flash) == nil
    and idle_ms >= IDLE_CLOSE_MS
  then
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

local function char_to_lane(char)
  if type(char) == "string" and #char > 0 then
    local low = string.lower(char:sub(1, 1))
    if QWERTY_MAP[low] then
      return QWERTY_MAP[low]
    end
    return (string.byte(low, 1) % 5) + 1
  end
  return math.random(1, 5)
end

function M.set_theme(is_heaven, bg_hex, rail_fg, level, streak)
  if is_heaven ~= nil then
    state.is_heaven = is_heaven and true or false
  end
  if type(bg_hex) == "string" and bg_hex ~= "" then
    state.bg_hex = bg_hex
  end
  if type(rail_fg) == "string" and rail_fg ~= "" then
    state.rail_fg = rail_fg
  end
  if type(level) == "number" then
    state.level = level
  end
  if type(streak) == "number" then
    state.streak = streak
  end

  apply_highlights()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    render()
  end
end

function M.hit(char, is_heaven, bg_hex, rail_fg, level, streak)
  if is_heaven ~= nil or bg_hex ~= nil or rail_fg ~= nil or level ~= nil or streak ~= nil then
    M.set_theme(is_heaven, bg_hex, rail_fg, level, streak)
  else
    apply_highlights()
  end

  local now = vim.uv.now()
  state.recent_hits[#state.recent_hits + 1] = now

  local is_open = (char == " " or char == "\r" or char == "\n")
  if is_open then
    state.notes[#state.notes + 1] = {
      open = true,
      z = Z_FAR,
    }
  else
    local lane = char_to_lane(char)
    if state.last_lane and state.last_lane ~= lane and (now - state.last_hit_ms) < 75 then
      state.lightnings[#state.lightnings + 1] = {
        lane_a = state.last_lane,
        lane_b = lane,
        y = 14.0,
        ttl = 4,
      }
    end
    state.last_lane = lane
    state.notes[#state.notes + 1] = {
      lane = lane,
      z = Z_FAR,
    }
  end

  state.last_hit_ms = now
  render()
  ensure_timer()
end

function M.close()
  if state.timer and state.timer_running then
    state.timer:stop()
    state.timer_running = false
  end
  state.notes = {}
  state.sparks = {}
  state.lightnings = {}
  state.target_flash = {}
  state.laser_flash = {}
  state.last_lane = nil
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  state.win = nil
end

return M
