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
