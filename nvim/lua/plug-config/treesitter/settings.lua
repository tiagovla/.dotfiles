local treesitter = require 'nvim-treesitter.configs'

treesitter.setup {
    -- ensure_installed = {"python", "c", "cpp", "html", "lua", "json", "css", "javascript"},
    ensure_installed = "all",
    highlight = {enable = true}
}
