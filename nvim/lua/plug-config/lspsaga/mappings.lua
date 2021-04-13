local map = require'utils.functions'["map"]

map('n', 'gh', "<cmd> lua require('lspsaga.provider').lsp_finder() <cr>")
map('n', 'ca', "<cmd> lua require('lspsaga.codeaction').code_action()<CR>")
map('v', 'ca', "<cmd> lua require('lspsaga.codeaction').range_code_action()<CR>")
map('n', 'K', "<cmd> lua require('lspsaga.hover').render_hover_doc()<CR>")
map('n', 'gs', "<cmd> lua require('lspsaga.signaturehelp').signature_help()<CR>")
map('n', 'gr', "<cmd> lua require('lspsaga.rename').rename()<CR>")
-- map('n', 'gd', "<cmd> lua require('lspsaga.provider').preview_definition()<CR>")
map('n', 'cd',
    "<cmd> lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>")
map('n', 'cc',
    "<cmd> lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>")
map('n', '[d',
    "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>")
map('n', 'd]',
    "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>")
