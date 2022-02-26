local utils = require "plugins.config.lsp.utils"

local configs = {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "use" } },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                },
                maxPreload = 10000,
            },
        },
    },
}

return configs
