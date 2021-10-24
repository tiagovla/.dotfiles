return {
    run = ":TSUpdate",
    config = function()
        require "plugins.config.treesitter.settings"
    end,
}
