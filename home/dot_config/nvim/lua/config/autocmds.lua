-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- 🔥 Pisca um 🔥 no cursor ao sair do Insert mode para o Normal mode
local fire_ns = vim.api.nvim_create_namespace("FireInsertLeave")
vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("FireInsertLeave", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= "" then
      return
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] - 1
    local col = pos[2]
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
    if col > #line then
      col = #line
    end

    local icon = (vim.g.power_preset == "heaven" or vim.g.power_ascended) and "✨" or "🔥"
    local ok, mark_id = pcall(vim.api.nvim_buf_set_extmark, buf, fire_ns, row, col, {
      virt_text = { { icon } },
      virt_text_pos = "overlay",
      hl_mode = "replace",
      priority = 200,
    })

    if ok and mark_id then
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(buf) then
          pcall(vim.api.nvim_buf_del_extmark, buf, fire_ns, mark_id)
        end
      end, 220)
    end
  end,
})

-- 💾 Flash/Brilho na linha, borda e statusline ao salvar o arquivo (:w / <C-s>)
local save_ns = vim.api.nvim_create_namespace("SaveFlash")
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("SaveFlash", { clear = true }),
  callback = function(ev)
    local buf = ev.buf
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
      return
    end
    local is_heaven = (vim.g.power_preset == "heaven" or vim.g.power_ascended)
    local fg = is_heaven and "#00f5ff" or "#39ff14"
    local bg = is_heaven and "#12384d" or "#142e1c"

    local old_win = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
    local old_flt = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
    local old_stl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })

    vim.api.nvim_set_hl(0, "SaveFlashLine", { bg = bg, fg = fg, bold = true })
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = fg })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = fg, bg = bg, bold = true })

    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local ok, mark_id = pcall(vim.api.nvim_buf_set_extmark, buf, save_ns, row, 0, {
      line_hl_group = "SaveFlashLine",
      priority = 240,
    })

    vim.defer_fn(function()
      if ok and mark_id and vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.api.nvim_buf_del_extmark, buf, save_ns, mark_id)
      end
      vim.api.nvim_set_hl(0, "WinSeparator", old_win)
      vim.api.nvim_set_hl(0, "FloatBorder", old_flt)
      vim.api.nvim_set_hl(0, "StatusLine", old_stl)
    end, 180)
  end,
})
