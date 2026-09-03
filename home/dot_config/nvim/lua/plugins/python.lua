return {
  -- 🐍 Seletor de Ambientes Virtuais Python (Poetry, Venv, Conda, Mise)
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = function(_, opts)
      if LazyVim.has("telescope.nvim") then
        opts = vim.tbl_deep_extend("force", opts or {}, {
          name = { "venv", ".venv", "env", ".env" },
        })
      end
      return opts
    end,
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Selecionar Python Venv", ft = "python" } },
  },
}
