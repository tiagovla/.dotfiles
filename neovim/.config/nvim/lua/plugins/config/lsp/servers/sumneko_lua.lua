local utils = require "plugins.config.lsp.utils"

local configs = {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
}

local luadev = require("lua-dev").setup {
    lspconfig = configs,
}

return luadev
