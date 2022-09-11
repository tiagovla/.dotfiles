local lspconfig = require "lspconfig"
local path = require "mason-core.path"

for type, _ in pairs { Error = "", Warn = "", Hint = "", Info = "" } do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
end

vim.diagnostic.config {
    virtual_text = {
        prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
}

-- python
local function get_python_path(workspace)
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end
    if vim.fn.filereadable(path.concat { workspace, "poetry.lock" }) then
        local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
        return path.concat { venv, "bin", "python" }
    end
    return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

lspconfig.pylance.setup {
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
    end,
    before_init = function(_, config)
        config.settings.python.analysis.stubPath = path.concat {
            vim.fn.stdpath "data",
            "site",
            "pack",
            "packer",
            "opt",
            "python-type-stubs",
        }
    end,
}

-- markdown
-- lspconfig.markdownls.setup {}
lspconfig.marksman.setup {}

--
lspconfig.tsserver.setup {}

-- lua
lspconfig.sumneko_lua.setup(require("lua-dev").setup { lspconfig = {} })

-- cpp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
lspconfig.clangd.setup {
    cmd = { "clangd", "--inlay-hints=true" },
    capabilities = capabilities,
}

-- latex
lspconfig.texlab.setup {
    flags = {
        allow_incremental_sync = false,
    },
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        texlab = {
            auxDirectory = "build",
            diagnosticsDelay = 50,
            build = {
                executable = "latexmk",
                -- forwardSearchAfter = true,
                -- onSave = true,
                args = {
                    "-pdf",
                    "-pdflatex=lualatex",
                    "-quiet",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-shell-escape",
                    "-pvc",
                    "-f",
                    "-outdir=build",
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
