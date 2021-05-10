local config = {
    config = function()
        pcall(require, "plug-config.lualine.settings")
    end,
    requires = {"kyazdani42/nvim-web-devicons"},
}

return config
