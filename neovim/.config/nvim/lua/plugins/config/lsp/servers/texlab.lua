local utils = require "plugins.config.lsp.utils"

local configs = {
    flags = {
        allow_incremental_sync = false,
    },
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        utils.common.on_attach(client, bufnr)
    end,
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        texlab = {
            diagnosticsDelay = 50,
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-pvc",
                    "-synctex=1",
                    "-shell-escape",
                    "%f",
                },
            },
            forwardSearch = {
                args = { "--synctex-forward", "%l:1:%f", "%p" },
                executable = "zathura",
            },
            chktex = { onOpenAndSave = true, onEdit = false },
            formatterLineLength = 120,
        },
    },
}

return configs
