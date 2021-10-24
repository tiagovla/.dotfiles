local M = {}

local b, g, o, w, cmd = vim.bo, vim.g, vim.o, vim.wo, vim.cmd

function M.setup()
    M.options()
    M.window_options()
    M.buffer_options()
    M.commands()
    g.doge_doc_standard_python = "numpy"
end

function M.options()
    g.python3_host_prog = "$HOME/.pyenv/versions/3.9.5/bin/python3.9"
    o.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"
    o.clipboard = "unnamedplus"
    o.cmdheight = 1
    o.completeopt = "menuone,noinsert,noselect"

    o.history = 1000
    o.hlsearch = true
    o.inccommand = "split"
    o.incsearch = true
    o.infercase = true
    o.joinspaces = false

    o.scrolloff = 10
    o.sidescrolloff = 8

    o.showbreak = "↳"
    o.smarttab = true
    o.smartcase = true

    o.splitright = true
    o.splitbelow = true

    o.termguicolors = true
    o.wildmode = "list:longest"

    o.shiftwidth = 4
    o.tabstop = 4
    o.softtabstop = 0
    o.expandtab = true
    o.smartindent = true
    o.shiftwidth = 4
    o.expandtab = true

    g.showtabline = 2
    o.hidden = true
    o.shortmess = o.shortmess .. "cAI"
    o.showmode = false
    o.hlsearch = false
    o.mouse = "a"
    w.list = true
    w.listchars = "tab:!·,trail:."
    o.synmaxcol = 150
    g.tex_conceal = "abdgms"
    o.undofile = true
    o.cursorline = true
end

function M.window_options()
    w.list = true
    w.number = true
    w.relativenumber = true
    w.wrap = false
    w.colorcolumn = "80"
    w.conceallevel = 1
end

function M.buffer_options()
    b.undofile = true
    b.shiftwidth = 4
    b.tabstop = 4
    b.softtabstop = 0
    b.expandtab = true
    b.smartindent = true
    b.shiftwidth = 4
    b.expandtab = true
end

function M.commands()
    cmd "syntax on"
    cmd "set t_ZH=^[[3m"
    cmd "set t_ZR=^[[23m"
    cmd ":nmap <F1> <nop>"
    cmd ":imap <F1> <nop>"
    cmd ":nnoremap Y y$"
    cmd ":nnoremap n nzzzv"
    cmd ":nnoremap N Nzzzv"
    cmd ":nnoremap G Gzzzv"
    cmd ":nnoremap J mzJ`z"

    cmd ":inoremap , ,<c-g>u"
    cmd ":inoremap . .<c-g>u"
    cmd ":inoremap ! !<c-g>u"
    cmd ":inoremap ? ?<c-g>u"

    cmd ":vnoremap J :m .+1<cr>gv=gv"
    cmd ":vnoremap K :m .-2<cr>gv=gv"

    cmd [[ autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300} ]]
end

M.setup()
