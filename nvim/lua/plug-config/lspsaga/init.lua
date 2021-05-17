pcall(require, "plug-config.lspsaga.mappings")

local config = {
    cmd = "Lspsaga",
    config = function()
        require "plug-config.lspsaga.settings"
    end,
}

return config
