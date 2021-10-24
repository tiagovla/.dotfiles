return {
    event = "VimEnter",
    config = function()
        require "plugins.config.whichkey.mappings"
        require "plugins.config.whichkey.settings"
    end,
}
