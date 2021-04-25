require('lspinstall').setup()
local nvim_lsp = require('lspconfig')

_G.formatting = function()
    if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
        vim.lsp.buf.formatting_sync(nil, 1000)
    end
end

local on_attach = function(client, bufnr)

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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
            diagnostics = {globals = {"vim", "use"}},
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
local clangf = {formatCommand = "clang-format", formatStdin = true}
local yapf = {formatCommand = "yapf --quiet", formatStdin = true}
local luaf = {formatCommand = "lua-format", formatStdin = true}
local latexindent = {formatCommand = "latexindent", formatStdin = true}
local cmakef = {formatCommand = 'cmake-format', formatStdin = true}
local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}
local prettier = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}
local shellcheck = {
    LintCommand = 'shellcheck -f gcc -x',
    lintFormats = {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'}
}

nvim_lsp["efm"].setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true, codeAction = false},
    filetypes = {"lua", "python", "cpp", "sh", "json", "yaml", "css", "html"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {isort, yapf},
            lua = {luaf},
            tex = {latexindent},
            sh = {shellcheck, shfmt},
            cmake = {cmakef},
            html = {prettier},
            css = {prettier},
            json = {prettier},
            yaml = {prettier},
            cpp = {clangf}
        }
    }
}

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
        nvim_lua = true
        -- ultisnips = true
    }
}



