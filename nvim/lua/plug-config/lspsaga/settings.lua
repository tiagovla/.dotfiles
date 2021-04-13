local saga = require 'lspsaga'

saga.init_lsp_saga {
    error_sign = '',
    warn_sign = '',
    hint_sign = '',
    infor_sign = ''
}

saga.init_lsp_saga()

-- vim.cmd [[hi! link DiagnosticError Red]]
-- vim.cmd [[hi! link DiagnosticWarning Yellow]]
-- vim.cmd [[hi! link DiagnosticHint Purple]]
-- vim.cmd [[hi! link DiagnosticWarning Green]]

vim.api.nvim_exec([[
hi! LspDiagnosticsDefaultWarning cterm=bold ctermbg=blue guibg=LightYellow
hi! LspDiagnosticsDefaultError cterm=bold ctermbg=blue guibg=LightYellow
hi! DiagnosticHint cterm=bold ctermbg=blue guibg=LightYellow
hi! DiagnosticWarning cterm=bold ctermbg=blue guibg=LightYellow
]], false)
