return {
    config = function()
        require "lsp.semantic_tokens"
        require "plugins.config.lsp.settings"
        require "plugins.config.lsp.installers"
        require "plugins.config.lsp.handlers"
        require "plugins.config.lsp.servers"
        vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
        end, 0)
    end,
}
