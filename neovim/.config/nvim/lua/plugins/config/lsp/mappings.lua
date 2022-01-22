local keymap = vim.keymap
local lsp = vim.lsp

keymap.set({ "n" }, "ga", vim.lsp.buf.code_action)
keymap.set({ "v" }, "ga", ":lua vim.lsp.buf.range_code_action()<cr>")
keymap.set("n", "gD", lsp.buf.declaration)
keymap.set("n", "gd", lsp.buf.definition)
keymap.set("n", "gi", lsp.buf.implementation)
keymap.set("n", "gr", lsp.buf.rename)
keymap.set("n", "K", vim.lsp.buf.hover)
keymap.set("n", "<C-k>", lsp.buf.signature_help)
keymap.set("n", "gR", lsp.buf.references)
keymap.set("n", "<leader>e", vim.diagnostic.open_float)
keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>")
keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>")
