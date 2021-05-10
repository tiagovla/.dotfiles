local config = {
    run = ":TSUpdate",
    event = "BufRead",
    config = function()
        require "plug-config.treesitter.settings"
    end,
}

return config
