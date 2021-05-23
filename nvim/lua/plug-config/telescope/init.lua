pcall(require, "plug-config.telescope.mappings")

local config = {
    cmd = {"Telescope"},
    requires = {
        {"nvim-lua/popup.nvim", opt = true}, {"nvim-lua/plenary.nvim", opt = true},
        {"nvim-telescope/telescope-media-files.nvim", opt = true},
    },
    after = {"nvim-treesitter"},
    config = function()
        if not _G.packer_plugins["plenary.nvim"].loaded then
            vim.cmd [[packadd plenary.nvim]]
            vim.cmd [[packadd popup.nvim]]
            vim.cmd [[packadd telescope-media-files.nvim]]
        end
        require "plug-config.telescope.settings"
    end,
}

return config
