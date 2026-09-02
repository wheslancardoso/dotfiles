-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Formatação automática ao salvar
vim.g.autoformat = true

-- Sincronização direta com clipboard do Wayland/X11 (wl-copy / xclip)
vim.opt.clipboard = "unnamedplus"

-- Numeração de linhas híbrida (relativa + absoluta)
vim.opt.relativenumber = true
vim.opt.number = true

-- Tabulações e Indentação
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Suporte a cores no terminal 24-bit
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Histórico de desfazer persistente entre sessões
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Busca inteligente
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tempo de resposta ágil
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

-- Detecção automática de tipos de arquivos especiais (Hyprland, Zellij, etc.)
vim.filetype.add({
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
    ["hyprland%.conf"] = "hyprlang",
    [".*%.kdl"] = "kdl",
  },
})
