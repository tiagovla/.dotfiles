local lspconfig = require "lspconfig"
local utils = require "plugins.config.lsp.utils"

lspconfig.cmake.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        utils.common.on_attach(client, bufnr)
    end,
}
