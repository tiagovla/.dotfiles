require "plugins.config.nvimtree.mappings"

local plug_config = {
    cmd = {
        "NvimTreeOpen",
        "NvimTreeToggle",
        "NvimTreeFindFile",
        "NvimTreeRefresh",
    },
    module = "nvim-tree",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
        require "plugins.config.nvimtree.settings"
    end,
}

return plug_config
