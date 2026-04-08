vim.diagnostic.config {
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "", -- ""
            [vim.diagnostic.severity.WARN] = "", -- ""
            [vim.diagnostic.severity.HINT] = "", -- ""
            [vim.diagnostic.severity.INFO] = "", -- ""
        },

        linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "None",
            [vim.diagnostic.severity.HINT] = "None",
            [vim.diagnostic.severity.INFO] = "None",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
    },
    underline = true,
    update_in_insert = false,
    float = { border = "rounded", scope = "line", header = "" },
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
            return
        end

        vim.bo[buffer].formatexpr = "" --  yikes

        if client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup("DocumentHighlight", {})
            vim.api.nvim_create_autocmd("CursorHold", {
                group = group,
                buffer = 0,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = group,
                buffer = 0,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if client.server_capabilities.documentFormattingProvider then
            local group = vim.api.nvim_create_augroup("Formatting", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = group,
                buffer = 0,
                callback = function()
                    if vim.g.format_on_save then
                        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] = nil
                        vim.lsp.buf.format {
                            timeout_ms = 3000,
                        }
                    end
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.lsp.handlers["window/logMessage"] = function(_, content, _)
    if content.type == 3 then
        if content.message:find "pythonPath" then
            vim.notify(content.message)
        end
    end
end

vim.api.nvim_create_user_command("ToggleFormatting", function()
    vim.g.format_on_save = not vim.g.format_on_save
    vim.notify("Formatting on save " .. (vim.g.format_on_save and "enabled" or "disabled"))
end, {})
