pcall(require, "plug-config.nvimtree.mappings")

local config = {
    -- cmd = {
    --     "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeRefresh"
    -- },
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function() require "plug-config.nvimtree.settings" end
}

return config
