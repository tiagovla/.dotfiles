local M = {}

local b = vim.bo
local g = vim.g
local o = vim.o
local w = vim.wo
local cmd = vim.cmd

function M.setup()
    M.options()
    M.window_options()
    M.command()
end

function M.options()

    g.python3_host_prog = '~/.pyenv/versions/3.8.9/bin/python3'

    o.clipboard = 'unnamedplus'
    o.cmdheight = 1
    o.completeopt = 'menuone,noinsert,noselect'

    o.history = 1000
    o.hlsearch = true
    o.inccommand = 'split'
    o.incsearch = true
    o.infercase = true
    o.joinspaces = false

    o.scrolloff = 10
    o.sidescrolloff = 8

    o.showbreak = '↳'
    o.smarttab = true
    o.smartcase = true

    o.splitright = true
    o.splitbelow = true

    o.termguicolors = true
    o.wildmode = 'list:longest'

    b.shiftwidth = 4
    b.tabstop = 4
    b.softtabstop = 0
    b.expandtab = true
    b.smartindent = true
    b.shiftwidth = 4
    b.expandtab = true

    o.shiftwidth = 4
    o.tabstop = 4
    o.softtabstop = 0
    o.expandtab = true
    o.smartindent = true
    o.shiftwidth = 4
    o.expandtab = true

    g.showtabline = 2
    -- vim.api.nvim_command('set showtabline=2')
    -- vim.api.nvim_command('set noshowmode')
    -- vim.api.nvim_command('set hidden')
    vim.api.nvim_command('set hidden')
    vim.api.nvim_command('set noshowmode')
    vim.api.nvim_command('set shortmess+=c')
    vim.api.nvim_command('set nohlsearch')
    vim.api.nvim_command('set mouse=a')
    vim.api.nvim_command('set listchars=tab:!·,trail:·')
    vim.api.nvim_command('set t_ZH=^[[3m')
    vim.api.nvim_command('set t_ZR=^[[23m')
    vim.api.nvim_command('set cursorline')
end

function M.window_options()
    w.list = true
    w.number = true
    w.relativenumber = true
    w.wrap = false
    w.colorcolumn = '80'
end

function M.command()
    cmd([[
        function! SynGroup()
            let l:s = synID(line('.'), col('.'), 1)
            echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
        endfun
    ]])
    cmd([[nmap <F10> :call SynGroup() <cr>]])
    cmd(
        [[ autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights() ]])
    cmd(
        [[ autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300} ]])
end

return M
