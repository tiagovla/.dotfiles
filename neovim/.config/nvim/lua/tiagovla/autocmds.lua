local function highlight_on_yank()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
end

vim.api.nvim_create_autocmd("TextYankPost", { callback = highlight_on_yank })
