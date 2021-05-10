local config = {
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function()
        pcall(require, "plug-config.bufferline.settings")
    end,
}

return config
