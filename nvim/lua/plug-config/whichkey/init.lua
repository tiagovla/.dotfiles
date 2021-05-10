pcall(require, "plug-config.whichkey.mappings")

local config = {
    cmd = {"WhichKey"},
    config = function()
        require "plug-config.whichkey.settings"
    end,
}

return config
