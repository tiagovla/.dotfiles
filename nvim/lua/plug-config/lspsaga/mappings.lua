local lspsaga_mappings = {
    {'n', 'gh', ":lua require('lspsaga.provider').lsp_finder() <cr>"},
    {'n', '<space>ca', ":lua require('lspsaga.codeaction').code_action()<CR>"},
    {'v', '<space>ca', ":lua require('lspsaga.codeaction').range_code_action()<CR>"},
    {'n', 'K', ":lua require('lspsaga.hover').render_hover_doc()<CR>"},
    {'n', 'gs', ":lua require('lspsaga.signaturehelp').signature_help()<CR>"},
    {'n', 'gr', ":lua require('lspsaga.rename').rename()<CR>"},
    {'n', '<space>gd', ":lua require('lspsaga.provider').preview_definition()<CR>"},
    {'n', 'cd', ":lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>"},
    {'n', 'cc', ":lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>"},
    {'n', '[d', ":lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>"},
    {'n', 'd]', ":lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>"}
}
require'ezmap'.map(lspsaga_mappings, {'noremap', 'silent'})
