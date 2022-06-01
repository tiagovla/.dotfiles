local utils = require "plugins.config.lsp.utils"

local configs = {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        utils.common.on_attach(client, bufnr)
    end,
}

return configs
