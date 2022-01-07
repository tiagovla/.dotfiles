local keymap = vim.keymap
local lsp = vim.lsp

keymap.set("n", "gD", lsp.buf.declaration)
keymap.set("n", "gd", lsp.buf.definition)
keymap.set("n", "gi", lsp.buf.implementation)
keymap.set("n", "gr", lsp.buf.rename)
keymap.set("n", "<C-k>", lsp.buf.signature_help)
keymap.set("n", "gR", lsp.buf.references)
keymap.set("n", "<leader>e", lsp.diagnostic.show_line_diagnostics)
keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>")
keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>")
