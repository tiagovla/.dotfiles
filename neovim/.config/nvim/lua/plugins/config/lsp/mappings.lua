local keymap = vim.keymap
local lsp = vim.lsp
local mappings = {}

local opt = { buffer = 0 }

mappings.texlab = function()
    keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>", opt)
    keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", opt)
end

function mappings.setup(client_name)
    keymap.set({ "n" }, "ga", vim.lsp.buf.code_action, opt)
    keymap.set({ "v" }, "ga", ":lua vim.lsp.buf.range_code_action()<cr>", opt)
    keymap.set("n", "gD", lsp.buf.declaration, opt)
    keymap.set("n", "gd", lsp.buf.definition, opt)
    keymap.set("n", "gi", lsp.buf.implementation, opt)
    keymap.set("n", "gr", lsp.buf.rename, opt)
    keymap.set("n", "gT", lsp.buf.type_definition, opt)
    keymap.set("n", "K", vim.lsp.buf.hover, opt)
    -- keymap.set("n", "<leader>gk", lsp.buf.signature_help, opt)
    keymap.set("n", "gR", lsp.buf.references, opt)
    keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opt)
    if mappings[client_name] then
        mappings[client_name]()
    end
end

return mappings
