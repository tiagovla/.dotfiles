local M = {}

local g, opt, cmd = vim.g, vim.opt, vim.cmd

function M.setup()
    M.options()
    M.globals()
    M.window_options()
    M.buffer_options()
    M.commands()
    M.builtins()
end

function M.globals()
    g.python3_host_prog = "$HOME/.asdf/shims/python"
    g.format_on_save = true
    g.tex_conceal = "abdgms"
    g.tex_flavor = "latex"
end

function M.options()
    opt.sessionoptions = {
        "blank",
        "buffers",
        "curdir",
        "folds",
        "help",
        "options",
        "tabpages",
        "winsize",
        "resize",
        "winpos",
        "terminal",
    }
    opt.clipboard = "unnamedplus"
    opt.backupdir:remove { "." }

    opt.backup = true
    opt.backupcopy = "yes"
    opt.cmdheight = 1
    opt.completeopt = { "menuone", "noinsert", "noselect" }

    opt.history = 1000
    opt.joinspaces = false

    opt.incsearch = true
    opt.infercase = true
    opt.inccommand = "split"

    opt.scrolloff = 10
    opt.sidescrolloff = 10

    opt.showbreak = "↳"
    opt.smarttab = true
    opt.wildmode = { list = "longest" }

    opt.termguicolors = true

    opt.shiftwidth = 4
    opt.tabstop = 4
    opt.softtabstop = 0
    opt.expandtab = true
    opt.smartindent = true
    opt.shiftwidth = 4
    opt.expandtab = true

    opt.fillchars = { eob = " " }

    opt.hidden = true
    opt.ignorecase = true
    opt.smartcase = true
    opt.mouse = "a"

    opt.shortmess:append "cAIfs"
    opt.signcolumn = "yes"
    opt.splitbelow = true
    opt.splitright = true

    opt.timeoutlen = 400

    opt.showmode = false
    opt.hlsearch = true
    opt.synmaxcol = 150
    opt.cursorline = true
    opt.updatetime = 250
    opt.whichwrap:append "<>[]hl"

    opt.undofile = true

    opt.expandtab = true
    opt.smartindent = true
    opt.shiftwidth = 4
    opt.tabstop = 8

    opt.number = true
    opt.numberwidth = 2
    opt.relativenumber = true
    opt.ruler = false

    opt.wrap = false

    opt.listchars = {
        tab = "!·",
        nbsp = "␣",
        trail = "·",
        eol = "↲",
    }
    opt.list = true
    opt.colorcolumn = tostring(80)
    opt.conceallevel = 1
end

function M.window_options() end

function M.buffer_options() end

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
    g.did_load_filetypes = 1
end

function M.commands()
    cmd "set fsync"
    cmd "set t_ZH=^[[3m"
    cmd "set t_ZR=^[[23m"
    cmd [[ :cab W w]]
    cmd [[ :cab Q q]]
    cmd [[nnoremap * :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>]]
    cmd [[nnoremap # :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>]]
end

M.setup()
