local config = {
    event = "BufReadPre",
    config = function()
        require "plug-config.lspkind.settings"
    end,
}

return config

