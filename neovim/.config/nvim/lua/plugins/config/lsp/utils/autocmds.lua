local M = {}

M.DocumentHighlightAU = function()
    vim.cmd [[
        augroup DocumentHighlight
        autocmd! * <buffer>
        autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
    ]]
end

M.SemanticTokensAU = function()
    vim.cmd [[
        augroup SemanticTokens
        autocmd! * <buffer>
        autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.buf.semantic_tokens_full()
        augroup END
    ]]
end

M.DocumentFormattingAU = function()
    vim.cmd [[
        augroup Formatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
        augroup END
    ]]
end

M.InlayHintsAU = function()
    vim.cmd [[
        augroup InlayHints
            autocmd! * <buffer>
            autocmd! CursorMoved,InsertLeave <buffer> lua require"lsp.inlay_hints".inlay_hints({ enabled = { "TypeHint", "ChainingHint", "ParameterHint" } })
        augroup END
    ]]
end

return M
