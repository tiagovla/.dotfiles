local M = {}

local b, g, o, w, cmd = vim.bo, vim.g, vim.o, vim.wo, vim.cmd

function M.setup()
    M.options()
    M.window_options()
    M.buffer_options()
    M.commands()
    M.builtins()
end

function M.options()
    g.python3_host_prog = "$HOME/.asdf/shims/python"
    g.format_on_save = true
    o.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal"
    o.clipboard = "unnamedplus"
    o.cmdheight = 1
    o.completeopt = "menuone,noinsert,noselect"

    o.history = 1000
    o.inccommand = "split"
    o.incsearch = true
    o.infercase = true
    o.joinspaces = false

    o.scrolloff = 10
    o.sidescrolloff = 8

    o.showbreak = "↳"
    o.smarttab = true
    o.smartcase = true
    o.ignorecase = true

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
    vim.go.laststatus = 2

    g.showtabline = 2

    o.hidden = true
    o.shortmess = o.shortmess .. "cAIF"
    o.showmode = false
    o.hlsearch = true
    o.mouse = "a"
    w.list = true
    w.listchars = "tab:!·,trail:.,eol:↲,nbsp:␣"
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

function M.builtins()
    g.loaded_gzip = 1
    g.loaded_zip = 1
    g.loaded_zipPlugin = 1
    g.loaded_tar = 1
    g.loaded_tarPlugin = 1

    g.loaded_getscript = 1
    g.loaded_getscriptPlugin = 1
    g.loaded_vimball = 1
    g.loaded_vimballPlugin = 1
    g.loaded_2html_plugin = 1

    g.loaded_matchit = 1
    g.loaded_matchparen = 1
    g.loaded_logiPat = 1
    g.loaded_rrhelper = 1

    g.loaded_netrw = 1
    g.loaded_netrwPlugin = 1
    g.loaded_netrwSettings = 1
    g.loaded_netrwFileHandlers = 1
end

function M.commands()
    cmd "set updatetime=1000"
    cmd "set t_ZH=^[[3m"
    cmd "set t_ZR=^[[23m"
    cmd "let g:tex_flavor='latex'"
    cmd [[ :cab W w]]
    cmd [[ :cab Q q]]
end

M.setup()
