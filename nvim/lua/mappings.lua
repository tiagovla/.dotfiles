local M = {}
local api = vim.api

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.setup()
    M.movements()
    M.telescope()
    M.compe()
end

function M.compe()
    map('i', '<C-Space>', 'compe#complete()',
        {noremap = true, silent = true, expr = true})
    -- map('i', '<CR>', 'compe#confirm("<CR>")',
    --     {noremap = true, silent = true, expr = true})
    map('i', '<C-e>', "compe#close('<C-e>')",
        {noremap = true, silent = true, expr = true})
end

function M.movements()
    map('n', '<C-F>f', '<C-W><C-J>')
    map('n', '<C-F>g', '<C-W><C-K>')
    map('n', '<C-F>b', '<C-W><C-L>')
    map('n', '<c-F>h', '<C-W><C-H>')
    map('n', '<c-N>', ':bnext<cr>', {noremap = true, silent = true})
    map('n', '<c-P>', ':bprev<cr>', {noremap = true, silent = true})
end

function M.telescope()
    map('n', '<C-F>', "<nop>")
    map('n', '<C-F>f', "<cmd>lua require('telescope.builtin').find_files()<cr>")
    map('n', '<C-F>g', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
    map('n', '<C-F>b', "<cmd>lua require('telescope.builtin').buffers()<cr>")
    map('n', '<C-F>h', "<cmd>lua require('telescope.builtin').help_tags()<cr>")
    map('n', '<C-F><C-F>',
        "<cmd>lua require('telescope.builtin').find_files()<cr>")
    map('n', '<C-F><C-G>',
        "<cmd>lua require('telescope.builtin').live_grep()<cr>")
    map('n', '<C-F><C-B>', "<cmd>lua require('telescope.builtin').buffers()<cr>")
    map('n', '<C-F><C-H>',
        "<cmd>lua require('telescope.builtin').help_tags()<cr>")
end

return M
