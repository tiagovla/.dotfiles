require'lspinstall'.setup()

local nvim_lsp = require('lspconfig')

_G.formatting = function()
    if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
        vim.lsp.buf.formatting_sync(nil, 1000)
    end
end

local on_attach = function(client, bufnr)

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                   opts)
    buf_set_keymap('n', '<space>wa',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   opts)
    buf_set_keymap('n', '<space>D',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e',
                   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                   opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                   opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                   opts)
    buf_set_keymap('n', '<space>q',
                   '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>",
                       opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>",
                       opts)
    end

    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua formatting()]]
        vim.cmd [[augroup END]]
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp["efm"].setup {on_attach = on_attach}
nvim_lsp["dockerfile"].setup {on_attach = on_attach}
nvim_lsp["python"].setup {on_attach = on_attach}
nvim_lsp["cpp"].setup {on_attach = on_attach}
nvim_lsp["bash"].setup {on_attach = on_attach}
nvim_lsp["cmake"].setup {on_attach = on_attach}
nvim_lsp["yaml"].setup {on_attach = on_attach}
nvim_lsp["html"].setup {on_attach = on_attach}
nvim_lsp["lua"].setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {globals = {"vim"}},
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                },
                maxPreload = 10000
            }
        }
    }
}
nvim_lsp["latex"].setup {
    capabilities = capabilities,
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        latex = {
            build = {onSave = true},
            forwardSearch = {
                args = {'--synctex-forward', '%l:1:%f', '%p'},
                executable = 'zathura',
                onSave = false
            },
            lint = {onChange = true}
        }
    }
}

local isort = {formatCommand = "isort --quiet -", formatStdin = true}
local yapf = {formatCommand = "yapf --quiet", formatStdin = true}
local luaf = {formatCommand = "lua-format", formatStdin = true}
local latexindent = {formatCommand = "latexindent", formatStdin = true}
local cmakef = {formatCommand = 'cmake-format', formatStdin = true}
local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}
local shellcheck = {
    LintCommand = 'shellcheck -f gcc -x',
    lintFormats = {
        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'
    }
}

nvim_lsp["efm"].setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true, codeAction = false},
    filetypes = {"lua", "python", "cpp", "sh", "json", "yaml"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {isort, yapf},
            lua = {luaf},
            tex = {latexindent},
            sh = {shellcheck, shfmt},
            cmake = {cmakef}
        }
    }
}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        ultisnips = true
    }
}

