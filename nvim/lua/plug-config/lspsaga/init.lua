pcall(require, "plug-config.lspsaga.mappings")

local config = {
    "glepnir/lspsaga.nvim",
    cmd = "Lspsaga",
    config = function()
        require "plug-config.lspsaga.settings"
    end,
}

return config
