require("lspconfig.ui.windows").default_options.border = "single"

require("mason").setup {
    ui = {
        border = "single",
    },
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local caps = client.server_capabilities

        vim.bo[buffer].formatexpr = "" --  yikes

        require("lsp-inlayhints").on_attach(client, buffer)
        if caps.documentHighlightProvider then
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

        if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
            vim.api.nvim_create_autocmd({ "TextChanged", "CursorHold", "InsertLeave" }, {
                group = augroup,
                buffer = 0,
                callback = function()
                    vim.lsp.buf.semantic_tokens_full()
                end,
            })
            vim.lsp.buf.semantic_tokens_full()
        end

        if caps.documentFormattingProvider then
            local group = vim.api.nvim_create_augroup("Formatting", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = group,
                buffer = 0,
                callback = function()
                    if vim.g.format_on_save then
                        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] = nil
                        vim.lsp.buf.format {
                            timeout_ms = 3000,
                            filter = function(c)
                                return c.name == "null-ls"
                            end,
                        }
                    end
                end,
            })
        end
    end,
})
