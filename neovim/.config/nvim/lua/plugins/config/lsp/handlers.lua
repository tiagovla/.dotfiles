local function on_window_logmessage(err, content, ctx)
    if content.type == 3 then
        vim.notify(content.message)
    end
end

vim.lsp.handlers["window/logMessage"] = on_window_logmessage
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
})
