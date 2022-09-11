local win = require "lspconfig.ui.windows"
local _default_opts = win.default_opts

win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
end

require("lsp-inlayhints").setup {}

require("mason-lspconfig").setup {
    ensure_installed = {
        "bashls",
        "html",
        "pylance",
        "sumneko_lua",
        "tsserver",
        "flake8",
        "black",
    },
    automatic_installation = true,
}

require("mason").setup {
    ui = {
        border = "single",
    },
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.server_capabilities.completionProvider then
            vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end
        if client.server_capabilities.definitionProvider then
            vim.api.nvim_buf_set_option(buffer, "tagfunc", "v:lua.vim.lsp.tagfunc")
        end
        if client.server_capabilities.inlayHintProvider or client.server_capabilities.clangdInlayHintsProvider then
            require("lsp-inlayhints").on_attach(client, buffer)
        end
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
        if client.server_capabilities.semanticTokensProvider and client.server_capabilities.semanticTokensProvider.full
        then
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

        if client.server_capabilities.documentFormattingProvider then
            local group = vim.api.nvim_create_augroup("Formatting", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = group,
                buffer = 0,
                callback = function()
                    if vim.g.format_on_save then
                        vim.lsp.buf.format { timeout_ms = 3000 }
                    end
                end,
            })
        end
    end,
})
