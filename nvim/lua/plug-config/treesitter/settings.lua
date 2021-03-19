local treesitter = require'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = {"python", "c", "cpp", "html", "lua", "json", "css", "javascript"},
  highlight = {
    enable = true,
  },
}
