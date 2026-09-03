return {
  -- 🦀 Crates.nvim para gerenciamento de dependências Cargo.toml no Rust
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
    },
  },
}
