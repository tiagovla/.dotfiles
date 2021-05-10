pcall(require, "plug-config.floaterm.mappings")

local config = {
    cmd = {"FloatermNew", "FloatermToggle", "FloatermNext", "FloatermPrev"},
    config = function()
        require("plug-config.floaterm.settings")
    end,
}

return config
