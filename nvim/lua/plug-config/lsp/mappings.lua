local map = require'utils.functions'["map"]

local lsp_mappings = {
    {'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>'},
    {'n', 'gd', ':lua vim.lsp.buf.definition()<CR>'},
    {'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>'},
    {'n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>'},
    {'n', '<space>wa', ':lua vim.lsp.buf.add_workspace_folder()<CR>'},
    {'n', '<space>wr', ':lua vim.lsp.buf.remove_workspace_folder()<CR>'},
    {'n', '<space>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'},
    {'n', '<space>D', ':lua vim.lsp.buf.type_definition()<CR>'},
    {'n', '<space>rn', ':lua vim.lsp.buf.rename()<CR>'},
    {'n', 'gR', ':lua vim.lsp.buf.references()<CR>'},
    {'n', '<space>e', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
    {'n', '<space>q', ':lua vim.lsp.diagnostic.set_loclist()<CR>'}
}
require'ezmap'.map(lsp_mappings, {'noremap', 'silent'})

local compe_mappings = {
    {'i', '<Tab>', 'v:lua.tab_complete()'}, {'s', '<Tab>', 'v:lua.tab_complete()'},
    {'i', '<S-Tab>', 'v:lua.s_tab_complete()'}, {'s', '<S-Tab>', 'v:lua.s_tab_complete()'}
}
require'ezmap'.map(compe_mappings, {'noremap', 'expr'})

local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

