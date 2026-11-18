local M = {}

local bit = bit or bit32

local HEIGHT = 5
local PH = HEIGHT * 4 -- 20 vertical sub-pixels
local TICK_MS = 33
local IDLE_CLOSE_MS = 8000
local HIT_Y = 18.0
local NOTE_SPEED = 0.90
local STAR_COUNT = 22

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

local PRIO_STAR = 1
local PRIO_FRET = 2
local PRIO_RAIL = 3
local PRIO_TARGET = 4
local PRIO_LASER = 5
local PRIO_TRAIL = 6
local PRIO_NOTE = 7
local PRIO_SPARK = 8

local ns = vim.api.nvim_create_namespace("GuitarHeroHighway")

local state = {
  buf = nil,
  win = nil,
  timer = nil,
  timer_running = false,
  notes = {},
  sparks = {},
  stars = {},
  target_flash = {},
  laser_flash = {},
  fret_phase = 0.0,
  last_hit_ms = 0,
  is_heaven = false,
  bg_hex = "#1e1e2e",
  rail_fg = "#7f849c",
}

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
  vim.api.nvim_set_hl(0, "GuitarHeroBg", { bg = state.bg_hex })
  vim.api.nvim_set_hl(0, "GuitarHeroRail", { fg = state.rail_fg, bg = state.bg_hex, bold = true })
  vim.api.nvim_set_hl(0, "GuitarHeroFret", { fg = state.rail_fg, bg = state.bg_hex })
  vim.api.nvim_set_hl(0, "GuitarHeroStar", {
    fg = state.is_heaven and "#7dd3fc" or "#fab387",
    bg = state.bg_hex,
  })
  vim.api.nvim_set_hl(0, "GuitarHeroHitBar", {
    fg = state.is_heaven and "#e0f2fe" or "#f5e0dc",
    bg = state.bg_hex,
    bold = true,
  })

  for i = 1, 5 do
    vim.api.nvim_set_hl(0, "GuitarHeroLane" .. i, {
      fg = palette[i],
      bg = state.bg_hex,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "GuitarHeroSpark" .. i, {
      fg = palette[i],
      bg = state.bg_hex,
      bold = true,
    })
  end
end

local function canvas_dims()
  local width = math.min(vim.o.columns, math.max(48, math.floor(vim.o.columns * 0.85)))
  return width, width * 2
end

local function project_x(u, y, pw)
  local center_x = (pw - 1) * 0.5
  local top_half_w = pw * 0.16
  local bot_half_w = pw * 0.36
  local t = math.max(0, math.min(1, y / (PH - 1)))
  local half_w = top_half_w + (bot_half_w - top_half_w) * t
  return center_x + u * half_w
end

local function spawn_star(pw, random_y)
  local side = (math.random(2) == 1) and -1 or 1
  local y = random_y and (math.random() * (PH - 2)) or (math.random() * 2.5)
  local edge_x = project_x(side, y, pw)
  local margin = 4 + math.random() * math.max(8, pw * 0.14)
  return {
    x = edge_x + side * margin,
    y = y,
    vx = side * (0.9 + math.random() * 1.4),
    vy = 0.55 + math.random() * 0.85,
  }
end

local function ensure_stars(pw)
  while #state.stars < STAR_COUNT do
    state.stars[#state.stars + 1] = spawn_star(pw, true)
  end
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
  for i = 1, total_cells do
    masks[i] = 0
    prios[i] = 0
    hls[i] = nil
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

  -- 2. Faster scrolling 3D perspective fret bars
  for k = 0, 4 do
    local p = (k + state.fret_phase) / 5.0
    local fy = (p ^ 1.45) * (HIT_Y - 0.5)
    local lx = project_x(-1.0, fy, pw)
    local rx = project_x(1.0, fy, pw)
    local sx = math.floor(lx + 0.5)
    local ex = math.floor(rx + 0.5)
    for px = sx, ex, 2 do
      plot(px, fy, "GuitarHeroFret", PRIO_FRET)
    end
  end

  -- 3. Double-pixel perspective outer rails & 4 inner lane dividers
  for py = 0, PH - 1 do
    local lx = project_x(-1.0, py, pw)
    local rx = project_x(1.0, py, pw)
    plot(lx, py, "GuitarHeroRail", PRIO_RAIL)
    plot(lx + 1, py, "GuitarHeroRail", PRIO_RAIL)
    plot(rx - 1, py, "GuitarHeroRail", PRIO_RAIL)
    plot(rx, py, "GuitarHeroRail", PRIO_RAIL)
    for _, du in ipairs(DIVIDER_U) do
      if py % 2 == 0 or py >= 15 then
        plot(project_x(du, py, pw), py, "GuitarHeroRail", PRIO_RAIL)
      end
    end
  end

  -- 4. Vertical laser/flame columns on impact
  for lane, ticks in pairs(state.laser_flash) do
    if ticks > 0 then
      local lane_hl = "GuitarHeroLane" .. lane
      local u = LANE_U[lane]
      for py = 0, HIT_Y do
        local cx = project_x(u, py, pw)
        plot(cx, py, lane_hl, PRIO_LASER)
        if py >= 6 then
          plot(cx - 1, py, lane_hl, PRIO_LASER)
          plot(cx + 1, py, lane_hl, PRIO_LASER)
        end
      end
    end
  end

  -- 5. Glowing hit-bar at y = 18 and 5 pulsing circular fret targets
  local bar_lx = project_x(-1.0, HIT_Y, pw)
  local bar_rx = project_x(1.0, HIT_Y, pw)
  draw_hline(bar_lx, bar_rx, HIT_Y, "GuitarHeroHitBar", PRIO_TARGET)

  for lane = 1, 5 do
    local tx = project_x(LANE_U[lane], HIT_Y, pw)
    local lane_hl = "GuitarHeroLane" .. lane
    local flash_ticks = state.target_flash[lane] or 0

    -- 5x3 circular fret ring
    for dx = -1, 1 do
      plot(tx + dx, HIT_Y - 1, lane_hl, PRIO_TARGET)
      plot(tx + dx, HIT_Y + 1, lane_hl, PRIO_TARGET)
    end
    plot(tx - 2, HIT_Y, lane_hl, PRIO_TARGET)
    plot(tx + 2, HIT_Y, lane_hl, PRIO_TARGET)

    if flash_ticks > 0 then
      -- Solid pulsing core + expanded outer ring
      for dx = -1, 1 do
        plot(tx + dx, HIT_Y, lane_hl, PRIO_SPARK)
      end
      plot(tx - 3, HIT_Y, lane_hl, PRIO_SPARK)
      plot(tx + 3, HIT_Y, lane_hl, PRIO_SPARK)
      plot(tx - 2, HIT_Y - 1, lane_hl, PRIO_SPARK)
      plot(tx + 2, HIT_Y - 1, lane_hl, PRIO_SPARK)
      plot(tx - 2, HIT_Y + 1, lane_hl, PRIO_SPARK)
      plot(tx + 2, HIT_Y + 1, lane_hl, PRIO_SPARK)
    end
  end

  -- 6. Bigger 5x3 Braille diamond/orb notes + tapered comet trails
  for _, note in ipairs(state.notes) do
    local lane_hl = "GuitarHeroLane" .. note.lane
    local u = LANE_U[note.lane]

    for step = 1, 5 do
      local ty = note.y - step * 0.95
      if ty >= 0 then
        local tx = project_x(u, ty, pw)
        plot(tx, ty, lane_hl, PRIO_TRAIL)
        if step <= 2 then
          plot(tx - 1, ty, lane_hl, PRIO_TRAIL)
          plot(tx + 1, ty, lane_hl, PRIO_TRAIL)
        end
      end
    end

    local nx = project_x(u, note.y, pw)
    for dx = -1, 1 do
      plot(nx + dx, note.y - 1, lane_hl, PRIO_NOTE)
      plot(nx + dx, note.y + 1, lane_hl, PRIO_NOTE)
    end
    for dx = -2, 2 do
      plot(nx + dx, note.y, lane_hl, PRIO_NOTE)
    end
  end

  -- 7. 12-spark Braille fountain explosions
  for _, sp in ipairs(state.sparks) do
    plot(sp.x, sp.y, "GuitarHeroSpark" .. sp.lane, PRIO_SPARK)
    if sp.ttl > 5 then
      plot(sp.x - sp.vx * 0.45, sp.y - sp.vy * 0.45, "GuitarHeroSpark" .. sp.lane, PRIO_SPARK)
    end
  end

  -- Build lines and merged highlight spans
  local lines = {}
  local row_spans = {}
  for cy = 0, HEIGHT - 1 do
    local chars = {}
    local spans = {}
    local byte_pos = 0
    local run_hl = nil
    local run_start = 0

    for cx = 0, width - 1 do
      local idx = cy * width + cx + 1
      local ch = mask_to_utf8(masks[idx])
      local hl = hls[idx]
      chars[cx + 1] = ch

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

  for row_idx, spans in ipairs(row_spans) do
    for _, sp in ipairs(spans) do
      vim.api.nvim_buf_set_extmark(state.buf, ns, row_idx - 1, sp[1], {
        end_col = sp[2],
        hl_group = sp[3],
      })
    end
  end

  local row = math.max(0, vim.o.lines - 7)
  local cur_win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_is_valid(cur_win) and cur_win ~= state.win then
    local cur_buf = vim.api.nvim_win_get_buf(cur_win)
    if vim.bo[cur_buf].buftype == "" then
      local cursor = vim.api.nvim_win_get_cursor(cur_win)
      local ok, sp = pcall(vim.fn.screenpos, cur_win, cursor[1], cursor[2] + 1)
      if ok and sp and sp.row > 0 and sp.row >= row then
        local push = (sp.row - row) + 2
        local view = vim.api.nvim_win_call(cur_win, vim.fn.winsaveview)
        local max_top = vim.api.nvim_buf_line_count(cur_buf)
        local new_top = math.min(max_top, view.topline + push)
        if new_top > view.topline then
          vim.api.nvim_win_call(cur_win, function()
            vim.fn.winrestview({ topline = new_top })
          end)
        end
      end
    end
  end
  local col = math.max(0, math.floor((vim.o.columns - width) / 2))

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
  state.fret_phase = (state.fret_phase + 0.12) % 1.0

  for i, st in ipairs(state.stars) do
    st.x = st.x + st.vx
    st.y = st.y + st.vy
    if st.x < 0 or st.x >= pw or st.y >= PH then
      state.stars[i] = spawn_star(pw, false)
    end
  end

  local next_notes = {}
  for _, note in ipairs(state.notes) do
    local next_y = note.y + NOTE_SPEED
    if next_y >= 17.5 then
      spawn_impact(note.lane)
    else
      note.y = next_y
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
    return (string.byte(char, 1) % 5) + 1
  end
  return math.random(1, 5)
end

function M.set_theme(is_heaven, bg_hex, rail_fg)
  if is_heaven ~= nil then
    state.is_heaven = is_heaven and true or false
  end
  if type(bg_hex) == "string" and bg_hex ~= "" then
    state.bg_hex = bg_hex
  end
  if type(rail_fg) == "string" and rail_fg ~= "" then
    state.rail_fg = rail_fg
  end

  apply_highlights()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    render()
  end
end

function M.hit(char, is_heaven, bg_hex, rail_fg)
  if is_heaven ~= nil or bg_hex ~= nil or rail_fg ~= nil then
    M.set_theme(is_heaven, bg_hex, rail_fg)
  else
    apply_highlights()
  end

  state.notes[#state.notes + 1] = {
    lane = char_to_lane(char),
    y = 0.0,
  }
  state.last_hit_ms = vim.uv.now()

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
  state.target_flash = {}
  state.laser_flash = {}
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  state.win = nil
end

return M
