local lspconfig = require "lspconfig"
local path = require "mason-core.path"

local caps = require("nvim-semantic-tokens").extend_capabilities(vim.lsp.protocol.make_client_capabilities())
caps = require("cmp_nvim_lsp").default_capabilities(caps)
caps.textDocument.completion.completionItem.snippetSupport = true
caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
caps.offsetEncoding = { "utf-16" }

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
lspconfig.pylance.setup {
    capabilities = caps,
    on_init = function(client)
        client.config.settings.python.pythonPath = (function(workspace)
            if vim.env.VIRTUAL_ENV then
                return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if vim.fn.filereadable(path.concat { workspace, "poetry.lock" }) then
                local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
                return path.concat { venv, "bin", "python" }
            end
            return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
        end)(client.config.root_dir)
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
lspconfig.marksman.setup {
    capabilities = caps,
}

-- javascript--
lspconfig.tsserver.setup {
    capabilities = caps,
}

-- lua
lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            hint = {
                arrayIndex = "Disable",
                enable = true,
                setType = true,
            },
            format = { enable = false },
            diagnostics = { libraryFiles = "Disable", globals = { "vim" } },
            runtime = {
                pathStrict = true,
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                library = function()
                    local ret = {}
                    local function add(lib)
                        for _, p in pairs(vim.fn.expand(lib .. "/lua", false, true)) do
                            p = vim.fn.fnamemodify(vim.loop.fs_realpath(p), ":h")
                            if p ~= "." then
                                table.insert(ret, p)
                            end
                        end
                    end

                    add "$VIMRUNTIME"
                    -- for _, site in pairs(vim.split(vim.o.packpath, ",")) do
                    --     add(site .. "/pack/*/opt/*")
                    --     add(site .. "/pack/*/start/*")
                    -- end
                    return ret
                end,
            },
        },
    },
}

-- rust
lspconfig.rust_analyzer.setup {}

-- cpp
lspconfig.cmake.setup {
    capabilities = caps,
}

-- cpp
lspconfig.clangd.setup {
    cmd = { "clangd", "--inlay-hints=true", "--enable-config" },
    capabilities = caps,
}

-- docker
lspconfig.dockerls.setup {
    capabilities = caps,
}

-- latex
lspconfig.texlab.setup {
    capabilities = caps,
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
                onSave = true,
                args = {
                    "-pdf",
                    "-pdflua",
                    "-quiet",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-shell-escape",
                    -- "-pvc",
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
