return {
    event = "BufReadPre",
    requires = { "nvim-lua/plenary.nvim", opt = true },
    config = function()
        if not _G.packer_plugins["plenary.nvim"].loaded then
            vim.cmd [[packadd plenary.nvim]]
        end
        require "plugins.config.gitsigns.settings"
    end,
}
