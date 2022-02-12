local lspconfigplus = require "lspconfigplus"
local efm_cfg = require("lspconfigplus.extra")["efm"]
local utils = require "plugins.config.lsp.utils"
local lsp_installer = require "nvim-lsp-installer"

require "plugins.config.lsp.custom_servers"

local configs = {}

utils.define_signs { Error = "", Warn = "", Hint = "", Info = "" }

vim.diagnostic.config {
    virtual_text = {
        prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
}

local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.resolved_capabilities.goto_definition == true then
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end
    -- if client.resolved_capabilities.semantic_tokens_full == true then
    --     vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.buf.semantic_tokens_full()]]
    -- end
    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
            augroup Highlight
                autocmd! * <buffer>
                autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
        vim.cmd [[augroup END]]
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
configs.pylance = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                completeFunctionParens = true,
                indexing = true,
            },
        },
    },
    before_init = function(_, config)
        local stub_path = require("lspconfig/util").path.join(
            vim.fn.stdpath "data",
            "site",
            "pack",
            "packer",
            "opt",
            "python-type-stubs"
        )
        config.settings.python.analysis.stubPath = stub_path
    end,
    on_init = function(client)
        client.config.settings.python.pythonPath = utils.get_python_path(client.config.root_dir)
    end,
}

-- sumneko_lua config
configs.sumneko_lua = {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "use" } },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                },
                maxPreload = 10000,
            },
        },
    },
}

-- texlab config
configs.texlab = {
    flags = {
        allow_incremental_sync = false,
    },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        texlab = {
            diagnosticsDelay = 50,
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-pvc",
                    "-synctex=1",
                    "-shell-escape",
                    "%f",
                },
            },
            forwardSearch = {
                args = { "--synctex-forward", "%l:1:%f", "%p" },
                executable = "zathura",
            },
            chktex = { onOpenAndSave = true, onEdit = false },
            formatterLineLength = 120,
        },
    },
}

-- EFM config
local isort = lspconfigplus.formatters.isort.setup {}
local black = lspconfigplus.formatters.black.setup {}
local shfmt = lspconfigplus.formatters.shfmt.setup {}
local shellcheck = lspconfigplus.linters.shellcheck.setup {}
local markdownlint = lspconfigplus.linters.markdownlint.setup {}
local pandoc_markdown = lspconfigplus.formatters.pandoc_markdown.setup {}
local rst_lint = lspconfigplus.linters.rst_lint.setup {}
local pandoc_rst = lspconfigplus.formatters.pandoc_rst.setup {}
-- local cmakelang = lspconfigplus.formatters.cmakelang.setup {}
local stylua = lspconfigplus.formatters.stylua.setup {}
-- local flake8 = lspconfigplus.linters.flake8.setup {}
local flake8 = {
    prefix = "flake8",
    lintCommand = "flake8 --ignore=E203,F401,F841,W503 --max-line-length 88 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintFormats = { "%.%#:%l:%c: %t%n %m" },
    rootMarkers = { "setup.cfg", "tox.ini", ".flake8" },
}

configs.efm = {
    root_dir = require("lspconfig").util.root_pattern { ".git/", "." },
    on_attach = on_attach,
    init_options = { documentFormatting = true },
    filetypes = {
        "lua",
        "python",
        "zsh",
        -- "javascript",
        "sh",
        "json",
        "yaml",
        "css",
        "html",
        "vim",
        "markdown",
        "rst",
        "tex",
    },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            rst = { rst_lint, pandoc_rst },
            python = { flake8, isort, black },
            markdown = { markdownlint, pandoc_markdown },
            lua = { stylua },
            tex = { efm_cfg.latexindent },
            sh = { shellcheck, shfmt },
            zsh = { shellcheck, shfmt },
            cmake = { efm_cfg.cmake_format },
            html = { efm_cfg.prettier },
            css = { efm_cfg.prettier },
            json = { efm_cfg.prettier },
            yaml = { efm_cfg.prettier },
        },
    },
}

configs.diagnosticls = {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    filetypes = { "tex", "markdown" },
    init_options = {
        linters = {
            textidote = {
                command = "textidote",
                debounce = 500,
                args = { "--type", "tex", "--check", "pt_BR", "--output", "singleline", "--no-color" },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "textidote",
                formatLines = 1,
                formatPattern = {
                    '\\(L(\\d+)C(\\d+)-L(\\d+)C(\\d+)\\):(.+)".+"$',
                    {
                        line = 1,
                        column = 2,
                        endLine = 3,
                        endColumn = 4,
                        message = 5,
                    },
                },
            },
        },
        filetypes = {
            markdown = "textidote",
            tex = "textidote",
        },
    },
}

-- configs.ltex = require "plugins.config.lsp.custom_servers.ltex"

lsp_installer.on_server_ready(function(server)
    local opts = configs[server.name] or { on_attach = on_attach }
    server:setup(opts)
end)
