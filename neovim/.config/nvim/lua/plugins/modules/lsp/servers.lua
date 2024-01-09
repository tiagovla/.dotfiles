local lspconfig = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local caps = cmp_nvim_lsp.default_capabilities()

caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
caps.offsetEncoding = { "utf-16" }
caps.textDocument.completion.completionItem.snippetSupport = true

for type, _ in pairs { Error = "", Warn = "", Hint = "", Info = "" } do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
end

vim.diagnostic.config {
    -- virtual_text = {
    --     prefix = "",
    -- },
    virtual_text = false,
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
                return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if workspace then
                local poetry_lock_path = vim.fs.joinpath(workspace, "poetry.lock")
                if vim.fn.filereadable(poetry_lock_path) then
                    local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
                    return vim.fs.joinpath(venv, "bin", "python")
                end
            end
            return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
        end)(client.config.root_dir)
    end,
    before_init = function(_, config)
        config.settings.python.analysis.stubPath = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "python-type-stubs")
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
lspconfig.lua_ls.setup {
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
                library = (function()
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
                    for _, site in pairs(vim.split(vim.o.packpath, ",")) do
                        add(site .. "/pack/*/opt/*")
                        add(site .. "/pack/*/start/*")
                    end
                    return ret
                end)(),
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
    -- cmd = { "texlab", "-vvvv", "--log-file", "/tmp/texlab.log" },
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

lspconfig.ltex.setup {
    capabilities = caps,
    on_attach = function()
        require("ltex_extra").setup {
            init_check = true,
        }
    end,
    settings = {
        ltex = {
            language = "en-US",
            checkFrequency = "save",
        },
    },
}

lspconfig["matlab_ls"].setup {
    settings = {
        matlab = {
            indexWorkspace = true,
            installPath = "/usr/local/MATLAB/R2023b",
            matlabConnectionTiming = "onStart",
            telemetry = true,
        },
    },
}

lspconfig["wolfram_ls"].setup {}

-- lspconfig.ruff_lsp.setup {
--     capabilities = caps,
--     init_options = {
--         settings = {
--             args = {},
--         },
--     },
-- }
