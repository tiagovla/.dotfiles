local ezmap = require "ezmap"

local lsp_mappings = {
    { "n", "gD", ":lua vim.lsp.buf.declaration()<CR>" },
    { "n", "gd", ":lua vim.lsp.buf.definition()<CR>" },
    { "n", "gi", ":lua vim.lsp.buf.implementation()<CR>" },
    { "n", "gr", ":lua vim.lsp.buf.rename()<CR>" },
    { "n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>" },
    { "n", "gR", ":lua vim.lsp.buf.references()<CR>" },
    { "n", "<space>e", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>" },
    { "n", "<space>q", "<cmd> TroubleToggle <cr>" },
    { "n", "<space>v", "<cmd> DiffviewOpen <cr>" },
}
ezmap.map(lsp_mappings, { "noremap", "silent" })
