local utils = require "plugins.config.lsp.utils"

local configs = {
    flags = {
        allow_incremental_sync = false,
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        utils.common.on_attach(client, bufnr)
    end,
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        texlab = {
            auxDirectory = "build",
            diagnosticsDelay = 50,
            build = {
                executable = "latexmk",
                -- forwardSearchAfter = true,
                -- onSave = true,
                args = {
                    "-pdf",
                    "-pdflatex=lualatex",
                    "-quiet",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-shell-escape",
                    "-pvc",
                    "-f",
                    "-outdir=build",
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
