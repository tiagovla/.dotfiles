local config = {
    ft = {"html", "css", "sass", "vim", "lua", "javascript", "typescript"},
    config = function()
        require "plug-config.colorizer.settings"
    end,
}

return config
