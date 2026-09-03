-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- 💾 Salvar & Sair Rápido
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Salvar arquivo" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Sair de tudo" })

-- 🧹 Limpar realce de busca ao apertar ESC
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Limpar busca e modo normal" })

-- 🪟 Navegação intuitiva entre splits
map("n", "<C-h>", "<C-w>h", { desc = "Janela à esquerda", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Janela à direita", remap = true })

-- 📐 Redimensionar splits com setas
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Aumentar altura" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Diminuir altura" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Diminuir largura" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Aumentar largura" })

-- 📑 Alternar entre Buffers abertos
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Próximo buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Fechar buffer atual" })

-- ⬆️⬇️ Mover linhas selecionadas para cima/baixo (Alt+j / Alt+k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Mover linha para baixo" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Mover linha para cima" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Mover linha para baixo" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Mover linha para cima" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Mover seleção para cima" })

-- 🚀 Git & LazyGit
map("n", "<leader>gg", function()
  if Snacks and Snacks.lazygit then
    Snacks.lazygit()
  else
    vim.cmd("LazyGit")
  end
end, { desc = "Abrir LazyGit" })

-- 🤖 Antigravity AI Terminal Toggle
map("n", "<leader>ai", function()
  if Snacks and Snacks.terminal then
    Snacks.terminal("agy", { cwd = vim.fn.getcwd() })
  else
    vim.cmd("terminal agy")
  end
end, { desc = "Antigravity CLI (agy)" })

-- 👑 Vim King: Ajuda Interativa, Busca de Comandos & Treino
map("n", "<leader>?", "<cmd>Telescope keymaps<cr>", { desc = "Buscar Qualquer Atalho do Neovim" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Buscar Atalhos (Telescope)" })
map("n", "<leader>vk", function()
  local file = vim.fn.expand("$HOME/dotfiles/docs/GUIA_ATALHOS_E_KEYBINDS_MESTRE.md")
  vim.cmd("view " .. file)
end, { desc = "Vim King Cheatsheet Mestre" })
map("n", "<leader>vg", "<cmd>VimBeGood<cr>", { desc = "Jogar Vim-Be-Good (Treino de Memória Muscular)" })

