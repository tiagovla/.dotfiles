vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/microsoft/python-type-stubs",
    "https://github.com/barreiroleo/ltex_extra.nvim",
}, { confirm = false })

vim.lsp.enable {
    "lua_ls",
    "pylance",
    "texlab",
    "dockerls",
    "astro",
    "tailwindcss",
    "marksman",
    "ts_ls",
    "ruff",
    "gopls",
    "cmake",
    "clangd",
    "ltex",
    "matlab_ls",
    "rust_analyzer",
    "qmlls",
    "wolfram_ls",
}

local caps = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

caps = vim.tbl_deep_extend("force", caps, {
    offsetEncoding = { "utf-16" },
    textDocument = {
        completion = {
            completionItem = {
                snippetSupport = true,
            },
        },
        onTypeFormatting = {
            dynamicRegistration = true,
        },
    },
})

vim.lsp.config("clangd", {
    cmd = { "clangd", "--inlay-hints=true", "--enable-config" },
    capabilities = caps,
})

require("mason").setup {
    ui = {
        border = "single",
    },
    registries = {
        "github:mason-org/mason-registry",
        "lua:mason.local.registry",
    },
}

vim.lsp.config("lua_ls", {
    capabilities = caps,
    settings = {
        Lua = {
            hint = {
                arrayIndex = "Disable",
                enable = true,
                setType = true,
            },
            format = { enable = false },
            diagnostics = { libraryFiles = "Disable", globals = { "vim", "hl" } },
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
                            p = vim.fn.fnamemodify(vim.uv.fs_realpath(p), ":h")
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
                    add "/usr/share/hypr/stubs"
                    return ret
                end)(),
            },
        },
    },
})

vim.lsp.config("texlab", {
    -- cmd = { "texlab", "-vvvv", "--log-file", "/tmp/texlab.log" },
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
                -- executable = "dockerlatexmk",
                onSave = true,
                args = {
                    "-pdf",
                    -- "-pdflua",
                    -- "-xelatex",
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
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            chktex = { onOpenAndSave = true, onEdit = false },
            formatterLineLength = 120,
            latexFormatter = "texlab",
        },
    },
})

vim.lsp.config("pylance", {
    capabilities = caps,
    before_init = function(_, config)
        config.settings.python.analysis.stubPath =
            vim.fs.joinpath(vim.fn.stdpath "data", "site", "pack", "core", "opt", "python-type-stubs")
    end,
})

vim.lsp.config("ruff", {
    capabilities = caps,
    cmd = { "ruff", "server" },
    settings = {},
})

vim.lsp.config("astro", {})

vim.lsp.config("tailwindcss", {
    capabilities = caps,
})

vim.lsp.config("marksman", {
    capabilities = caps,
})

vim.lsp.config("ts_ls", {
    capabilities = caps,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
})

vim.lsp.config("qmlls", {
    cmd = {
        -- vim.fn.stdpath "data" .. "/mason/bin/qmlls",
        "qmlls",
        "-I",
        "/usr/lib/qt6/qml",
    },
})

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
})

vim.lsp.config("cmake", {
    capabilities = caps,
})

-- vim.lsp.config("clangd", {
--     cmd = { "clangd", "--inlay-hints=true", "--enable-config" },
--     capabilities = caps,
-- })

vim.lsp.config("clice", {
    capabilities = caps,
})

vim.lsp.config("ltex", {
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
})

vim.lsp.config("matlab_ls", {
    settings = {
        matlab = {
            indexWorkspace = true,
            installPath = "/usr/local/MATLAB/R2023b",
            matlabConnectionTiming = "onStart",
            telemetry = true,
        },
    },
})

vim.lsp.config("wolfram_ls", {})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf
        local client_name = vim.lsp.get_client_by_id(args.data.client_id)["name"]

        if client_name == "texlab" then
            vim.keymap.set("n", "<leader>lb", "<cmd>LspTexlabBuild<CR>", { buffer = 0, desc = "Build document" })
            vim.keymap.set("n", "<leader>lv", function()
                vim.cmd.LspTexlabForward()
                vim.system({ "bash", "-c", "sleep 0.3 && hyprctl dispatch focuscurrentorlast" }, { detach = true })
            end, { buffer = 0, desc = "Forward view" })
        end

        if client_name == "clangd" then
            vim.keymap.set("n", "<Tab>", "<cmd>ClangdSwitchSourceHeader<CR>", { buffer = 0, desc = "Build document" })
        end

        vim.keymap.set("n", "<leader>o", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { buffer = buffer, desc = "Toggle typehints" })
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action" })
        vim.keymap.set("v", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action (range)" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "Go to declaration" })
        vim.keymap.set("n", "gd", function()
            local api = require "trouble.api"
            if api.is_open() then
                api.close()
            end
            vim.cmd.Trouble "lsp_definitions focus=true auto_close=true"
        end, { buffer = buffer, desc = "Go to definition" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "Go to inplementation" })
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename" })
        vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = buffer, desc = "Type definition" })
        vim.keymap.set(
            "n",
            "<leader>lq",
            vim.diagnostic.setloclist,
            { buffer = buffer, desc = "Diagnostics in local list" }
        )
        vim.keymap.set(
            "n",
            "<leader>lQ",
            vim.diagnostic.setqflist,
            { buffer = buffer, desc = "Diagnostics in quick list" }
        )
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover" })
        vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = buffer, desc = "References" })
        vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Signature help" })
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump { count = 1, float = true }
        end, { buffer = buffer, desc = "Next diagnostic" })
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump { count = -1, float = true }
        end, { buffer = buffer, desc = "Prev diagnostic" })
        vim.keymap.set(
            "n",
            "<leader>ge",
            vim.diagnostic.open_float,
            { buffer = buffer, desc = "Open float diagnostics" }
        )
    end,
})

local mr = require "mason-registry"

local ensure_installed = {
    "clangd",
    "astro-language-server",
    "black",
    "cmake-language-server",
    "cmakelang",
    "cmakelint",
    "cpplint",
    "cpptools",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "glsl_analyzer",
    "gofumpt",
    "golangci-lint",
    "gopls",
    "hadolint",
    "latexindent",
    "ltex-ls",
    "lua-language-server",
    "marksman",
    "matlab-language-server",
    "pydocstyle",
    "pylance",
    "ruff",
    "rust-analyzer",
    "shellcheck",
    "stylua",
    "tailwindcss-language-server",
    "texlab",
    "typescript-language-server",
    "yamlfmt",
}

mr.refresh(function()
    for _, name in ipairs(ensure_installed) do
        local ok_pkg, pkg = pcall(mr.get_package, name)
        if ok_pkg and not pkg:is_installed() then
            pkg:install() -- async
        end
    end
end)
