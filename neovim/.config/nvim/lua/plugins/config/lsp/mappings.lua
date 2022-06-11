local keymap = vim.keymap
local lsp = vim.lsp
local mappings = {}

vim.api.nvim_create_user_command("FormattingToggle", function()
    if vim.g.format_on_save then
        vim.g.format_on_save = false
        print "Formatting on save disabled"
    else
        vim.g.format_on_save = true
        print "Formatting on save enabled"
    end
end, {})

mappings.texlab = function()
    keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>", { buffer = 0, desc = "Build document" })
    keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", { buffer = 0, desc = "Forward view" })
end

local opt = { silent = true, buffer = 0 }
function mappings.setup(client_name)
    keymap.set({ "n" }, "ga", vim.lsp.buf.code_action, opt)
    keymap.set({ "v" }, "ga", ":lua vim.lsp.buf.range_code_action()<cr>", opt)
    keymap.set("n", "gD", lsp.buf.declaration, opt)
    keymap.set("n", "gd", lsp.buf.definition, opt)
    keymap.set("n", "gi", lsp.buf.implementation, opt)
    keymap.set("n", "gr", lsp.buf.rename, opt)
    keymap.set("n", "gT", lsp.buf.type_definition, opt)
    keymap.set("n", "K", vim.lsp.buf.hover, opt)
    keymap.set("n", "gR", lsp.buf.references, opt)
    keymap.set("n", "<leader>gk", lsp.buf.signature_help, opt)
    keymap.set("v", "<leader>f", ":lua vim.lsp.buf.range_formatting()<cr>", opt)
    keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opt)
    keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { timeout_ms = 3000 }
    end, { buffer = 0, desc = "Format buffer" })
    if mappings[client_name] then
        mappings[client_name]()
    end
end

return mappings
