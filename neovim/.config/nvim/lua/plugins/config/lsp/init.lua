return {
    config = function()
        require "plugins.config.lsp.custom"
        require "plugins.config.lsp.settings"
        require "plugins.config.lsp.mappings"
        require "plugins.config.lsp.handlers"
        require "plugins.config.lsp.null-ls"
        require "plugins.config.lsp.servers"
    end,
}
