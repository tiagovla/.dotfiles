local utils = require "plugins.config.lsp.utils"
local formatters = require "plugins.config.lsp.servers.efm.formatters"
local linters = require "plugins.config.lsp.servers.efm.linters"

local configs = {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
    root_dir = require("lspconfig").util.root_pattern { ".git/", "." },
    init_options = { documentFormatting = true },
    filetypes = {
        "python",
        "lua",
    },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            python = { formatters.isort, formatters.black, linters.flake8 },
            lua = { formatters.stylua },
        },
    },
}

return configs
