return {
    config = function()
        pcall(require, "tiagovla.plug_config.lualine.settings")
    end,
    requires = { "kyazdani42/nvim-web-devicons" },
}
