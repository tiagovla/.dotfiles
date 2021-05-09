local lspconfigplus = require("lspconfigplus")
local efm_cfg = require("lspconfigplus.extra")["efm"]

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[augroup Format]])
        vim.cmd([[autocmd! * <buffer>]])
        vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]])
        vim.cmd([[augroup END]])
    end
end

local servers = {"pyright", "vimls", "tsserver", "yamlls", "bashls", "dockerls", "cmake", "clangd"}
lspconfigplus.bulk_setup(servers, {on_attach = on_attach})

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
                args = {"--synctex-forward", "%l:1:%f", "%p"},
                executable = "zathura",
                onSave = false
            },
            lint = {onChange = true}
        }
    }
}

local isort = lspconfigplus.formatters.isort.setup {}
local yapf = lspconfigplus.formatters.yapf.setup {}
local lua_format = lspconfigplus.formatters.lua_format.setup {}
-- local stylua = lspconfigplus.formatters.stylua.setup {}

lspconfigplus.efm.setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    filetypes = {"lua", "python", "cpp", "sh", "json", "yaml", "css", "html", "vim"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {isort, yapf},
            lua = {lua_format},
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

