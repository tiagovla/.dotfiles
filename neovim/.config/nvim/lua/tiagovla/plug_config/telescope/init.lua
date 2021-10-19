require "tiagovla.plug_config.telescope.mappings"

return {
    cmd = { "Telescope", "SearchSession" },
    requires = {
        { "nvim-lua/popup.nvim", opt = true },
        { "nvim-lua/plenary.nvim", opt = true },
        { "nvim-telescope/telescope-media-files.nvim", opt = true },
        { "nvim-telescope/telescope-project.nvim" },
        { "$HOME/github/session-lens", opt = true },
    },
    after = { "nvim-treesitter" },
    config = function()
        if not _G.packer_plugins["plenary.nvim"].loaded then
            vim.cmd [[packadd plenary.nvim]]
            vim.cmd [[packadd popup.nvim]]
            vim.cmd [[packadd telescope-media-files.nvim]]
        end
        require "tiagovla.plug_config.telescope.settings"
    end,
}
