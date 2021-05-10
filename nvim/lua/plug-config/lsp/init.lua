pcall(require, "plug-config.lsp.mappings")

local config = {
    event = "BufReadPre",
    requires = {{"neovim/nvim-lspconfig", opt = true}},
    config = function()
        if not _G.packer_plugins["nvim-lspconfig"].loaded then
            vim.cmd [[packadd nvim-lspconfig]]
        end
        require "plug-config.lsp.settings"
    end,
}

return config
