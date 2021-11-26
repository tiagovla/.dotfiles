require "plugins.config.lsp.mappings"

return {
    -- event = "BufReadPre",
    requires = { { "neovim/nvim-lspconfig", opt = true } },
    config = function()
        if not _G.packer_plugins["nvim-lspconfig"].loaded then
            vim.cmd [[packadd nvim-lspconfig]]
        end
        require "plugins.config.lsp.settings"

        vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
        end, 0)
    end,
}
