local lspconfigplus = require "lspconfigplus"
local efm_cfg = require("lspconfigplus.extra")["efm"]
local utils = require "plugins.config.lsp.utils"

utils.define_signs { Error = "", Warn = "", Hint = "", Info = "" }

local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
        vim.cmd [[augroup END]]
    end
end

-- bulk config
local servers = {
    "vimls",
    "yamlls",
    "bashls",
    "dockerls",
    "cmake",
    "clangd",
    "rust_analyzer",
}
lspconfigplus.bulk_setup(servers, { on_attach = on_attach })

-- pyright config
lspconfigplus.pyright.setup {
    on_attach = on_attach,
    on_init = function(client)
        client.config.settings.python.pythonPath = utils.get_python_path(client.config.root_dir)
    end,
}

-- sumneko_lua config
lspconfigplus.sumneko_lua.setup {
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
lspconfigplus.texlab.setup {
    commands = {
        TexlabBuild = {
            function()
                utils.texlab_buf_build(0)
            end,
            description = "Build the current buffer",
        },
        TexlabForward = {
            function()
                utils.texlab_buf_search(0)
            end,
            description = "Forward search from current position",
        },
    },
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

lspconfigplus.efm.setup {
    root_dir = require("lspconfig").util.root_pattern { ".git/", "." },
    on_attach = on_attach,
    init_options = { documentFormatting = true },
    filetypes = {
        "lua",
        "python",
        "zsh",
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
            python = { isort, black },
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
