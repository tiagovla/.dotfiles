require "plugins.config.lsp.mappings"
require "plugins.config.lsp.handlers"

return {
    -- event = "BufReadPre",
    requires = {
        { "neovim/nvim-lspconfig", opt = true },
        { "williamboman/nvim-lsp-installer", opt = true },
    },
    config = function()
        if not _G.packer_plugins["nvim-lspconfig"].loaded then
            vim.cmd [[packadd nvim-lspconfig]]
            vim.cmd [[packadd nvim-lsp-installer]]
        end
        require "plugins.config.lsp.settings"

        vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
        end, 0)
    end,
}
