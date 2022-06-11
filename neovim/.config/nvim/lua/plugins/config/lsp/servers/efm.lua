local lspconfig = require "lspconfig"
local utils = require "plugins.config.lsp.utils"
local formatters = require "plugins.config.lsp.servers.efm.formatters"
local linters = require "plugins.config.lsp.servers.efm.linters"

lspconfig.efm.setup {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
    root_dir = require("lspconfig").util.root_pattern { ".git/", "." },
    init_options = { documentFormatting = true },
    filetypes = {
        "python",
        "lua",
        "sh",
        "tex",
        "cmake",
        "yaml",
    },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            python = { formatters.isort, formatters.black, linters.flake8 },
            lua = { formatters.stylua },
            sh = { formatters.shfmt },
            tex = { formatters.latexindent },
            cmake = { formatters.cmake_format },
            yaml = { formatters.prettier },
        },
    },
}
