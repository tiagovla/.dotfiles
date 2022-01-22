local function on_window_logmessage(err, content, ctx)
    if content.type == 3 then
        print(content.message)
    end
end

vim.lsp.handlers["window/logMessage"] = on_window_logmessage
