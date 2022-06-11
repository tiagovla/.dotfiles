local utils = require "plugins.config.lsp.utils"
local lspconfig = require "lspconfig"

lspconfig.rust_analyzer.setup {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
        utils.autocmds.InlayHintsAU()
    end,
}
