require "plugins.config.dap.mappings"
return {
    event = "VimEnter",
    config = function()
        require "plugins.config.dap.settings"
    end,
}
