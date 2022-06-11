local lspconfig = require "lspconfig"
local utils = require "plugins.config.lsp.utils"

lspconfig["black-formatter"].setup {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
    settings = {
        python = {
            editor = {
                defaultFormatter = "ms-python.black-formatter",
                formatOnSave = false,
            },
        },
    },
}
