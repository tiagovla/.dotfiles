local lspconfigplus = require "lspconfigplus"
local efm_cfg = require("lspconfigplus.extra")["efm"]
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local signs = { Error = "", Warn = "", Hint = "", Info = "" }

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local cfg = {
    bind = true,
    doc_lines = 2,
    floating_window = true,
    fix_pos = true,
    hint_scheme = "String",
    use_lspsaga = false,
    hi_parameter = "IncSearch",
    max_height = 12,
    max_width = 120,
    handler_opts = { border = "single" },
    extra_trigger_chars = {},
}

local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    require("lsp_signature").on_attach(cfg)
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
        vim.cmd [[augroup END]]
    end
end
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

local util = require "lspconfig/util"
local path = util.path

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    -- Find and use virtualenv via poetry in workspace directory.
    local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
    if match ~= "" then
        local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
        return path.join(venv, "bin", "python")
    end

    -- Fallback to system Python.
    return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

lspconfigplus.pyright.setup {
    on_attach = on_attach,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
    end,
}

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
lspconfigplus.texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        texlab = {
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
            chktex = { onOpenAndSave = true, onEdit = true },
            formatterLineLength = 120,
        },
    },
}
local isort = lspconfigplus.formatters.isort.setup {}
-- local yapf = lspconfigplus.formatters.yapf.setup {}
local black = lspconfigplus.formatters.black.setup {}
local shfmt = lspconfigplus.formatters.shfmt.setup {}
local shellcheck = lspconfigplus.linters.shellcheck.setup {}
local lua_format = lspconfigplus.formatters.lua_format.setup {}
local markdownlint = lspconfigplus.linters.markdownlint.setup {}
local pandoc_markdown = lspconfigplus.formatters.pandoc_markdown.setup {}
local rst_lint = lspconfigplus.linters.rst_lint.setup {}
local pandoc_rst = lspconfigplus.formatters.pandoc_rst.setup {}
-- local cmakelang = lspconfigplus.formatters.cmakelang.setup {}
local stylua = lspconfigplus.formatters.stylua.setup {}
lspconfigplus.efm.setup {
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
