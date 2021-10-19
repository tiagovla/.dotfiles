require "tiagovla.plug_config.nvimtree.mappings"

local plug_config = {
    cmd = {
        "NvimTreeOpen",
        "NvimTreeToggle",
        "NvimTreeFindFile",
        "NvimTreeRefresh",
    },
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
        require "tiagovla.plug_config.nvimtree.settings"
    end,
}

return plug_config
