local lspconfigplus = require('lspconfigplus')
local efm_cfg = require('lspconfigplus.extra')["efm"]
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
        vim.cmd [[augroup END]]
    end
end

-- TODO: add css, html, yaml, cmake, bash, cpp, dockerfile
lspconfigplus.pyright.setup {}
lspconfigplus.vimls.setup {}
lspconfigplus.tsserver.setup {}
lspconfigplus.yamlls.setup {}
lspconfigplus.bashls.setup {}
lspconfigplus.sumneko_lua.setup {
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
lspconfigplus.texlab.setup {
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
lspconfigplus.efm.setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true, codeAction = false},
    filetypes = {"lua", "python", "cpp", "sh", "json", "yaml", "css", "html", "vim"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {efm_cfg.isort, efm_cfg.yapf},
            lua = {efm_cfg.lua_format},
            tex = {efm_cfg.latexindent},
            sh = {efm_cfg.shellcheck, efm_cfg.shfmt},
            cmake = {efm_cfg.cmake_format},
            html = {efm_cfg.prettier},
            css = {efm_cfg.prettier},
            json = {efm_cfg.prettier},
            yaml = {efm_cfg.prettier},
            cpp = {efm_cfg.prettier}
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

