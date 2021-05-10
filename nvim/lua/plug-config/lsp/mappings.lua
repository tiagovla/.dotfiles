local ezmap = require("ezmap")

local lsp_mappings = {
    {"n", "gD", ":lua vim.lsp.buf.declaration()<CR>"},
    {"n", "gd", ":lua vim.lsp.buf.definition()<CR>"},
    {"n", "gi", ":lua vim.lsp.buf.implementation()<CR>"},
    {"n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>"},
    {"n", "<space>wa", ":lua vim.lsp.buf.add_workspace_folder()<CR>"},
    {"n", "<space>wr", ":lua vim.lsp.buf.remove_workspace_folder()<CR>"},
    {"n", "<space>wl", ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>"},
    {"n", "<space>D", ":lua vim.lsp.buf.type_definition()<CR>"},
    {"n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>"},
    {"n", "gR", ":lua vim.lsp.buf.references()<CR>"},
    {"n", "<space>e", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>"},
    {"n", "<space>q", ":lua vim.lsp.diagnostic.set_loclist()<CR>"},
}
ezmap.map(lsp_mappings, {"noremap", "silent"})
