local function config()
    local treesitter = require "nvim-treesitter.configs"
    treesitter.setup { ensure_installed = "all", highlight = { enable = true } }
end

return {
    run = ":TSUpdate",
    config = config,
}
