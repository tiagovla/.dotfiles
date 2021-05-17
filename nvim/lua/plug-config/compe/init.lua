pcall(require, "plug-config.compe.mappings")

local config = {
    event = "InsertEnter",
    config = function()
        require("plug-config.compe.settings")
    end,
}

return config
