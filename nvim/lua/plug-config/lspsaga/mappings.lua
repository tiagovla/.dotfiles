local lspsaga_mappings = {
    {"n", "gh", ":Lspsaga lsp_finder <cr>"}, {"n", "<space>ca", ":Lspsaga code_action<CR>"},
    {"v", "<space>ca", ":Lspsaga range_code_action<CR>"},
    {"n", "K", ":Lspsaga render_hover_doc<CR>"}, {"n", "gs", ":Lspsaga signature_help<CR>"},
    {"n", "gr", ":Lspsaga rename<CR>"}, {"n", "<space>gd", ":Lspsaga preview_definition<CR>"},
    {"n", "cd", ":Lspsaga show_line_diagnostics<CR>"},
    {"n", "cc", ":Lspsaga show_cursor_diagnostics<CR>"},
    {"n", "[d", ":Lspsaga lsp_jump_diagnostic_prev<CR>"},
    {"n", "d]", ":Lspsaga lsp_jump_diagnostic_next<CR>"},
}
require"ezmap".map(lspsaga_mappings, {"noremap", "silent"})
