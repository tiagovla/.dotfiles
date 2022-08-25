local Pkg = require "mason-core.package"
local configs = require "lspconfig.configs"
local lsp_util = require "vim.lsp.util"
local path = require "mason-core.path"
local util = require "lspconfig.util"
local index = require "mason-registry.index"

index["pylance"] = "plugins.config.lsp.custom.pylance"

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
}

local function extract_method()
    local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
    local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
    local params = {
        command = "pylance.extractMethod",
        arguments = arguments,
    }
    vim.lsp.buf.execute_command(params)
end

local function extract_variable()
    local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
    local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
    local params = {
        command = "pylance.extractVarible",
        arguments = arguments,
    }
    vim.lsp.buf.execute_command(params)
end

local function organize_imports()
    local params = {
        command = "pyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
    }
    vim.lsp.buf.execute_command(params)
end

local function on_workspace_executecommand(err, actions, ctx)
    if ctx.params.command:match "WithRename" then
        ctx.params.command = ctx.params.command:gsub("WithRename", "")
        vim.lsp.buf.execute_command(ctx.params)
    end
end


if not configs["pylance"] then
    configs["pylance"] = {
        default_config = {
            filetypes = { "python" },
            root_dir = util.root_pattern(unpack(root_files)),
            cmd = { "pylance", "--stdio" },
            single_file_support = true,
            capabilities = vim.lsp.protocol.make_client_capabilities(),
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                        typeCheckingMode = "basic",
                        completeFunctionParens = true,
                        indexing = false,
                        inlayHints = {
                            variableTypes = true,
                            functionReturnTypes = true,
                        },
                    },
                },
            },
            handlers = {
                ["workspace/executeCommand"] = on_workspace_executecommand,
            },
        },
        commands = {
            PylanceExtractMethod = {
                extract_method,
                description = "Extract Method",
            },
            PylanceExtractVarible = {
                extract_variable,
                description = "Extract Variable",
            },
            PylanceOrganizeImports = {
                organize_imports,
                description = "Organize Imports",
            },
        },
    }
end

local function installer(ctx)
    local script = [[
    curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' &&
    curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/latest/vspackage"
         -j -b cookies.txt --compressed --output "pylance.vsix"
    ]]
    ctx.receipt:with_primary_source(ctx.receipt.unmanaged)
    ctx.spawn.bash { "-c", script:gsub("\n", " ") }
    ctx.spawn.unzip { "pylance.vsix" }
    ctx.spawn.bash {
        "-c",
        [[sed -i "0,/\(if(\!process\[[^] ]*\]\[[^] ]*\])return\!0x\)1/ s//\10/" extension/dist/server.bundle.js]],
    }
    ctx:link_bin(
        "pylance",
        ctx:write_node_exec_wrapper("pylance", path.concat { "extension", "dist", "server.bundle.js" })
    )
end

return Pkg.new {
    name = "pylance",
    desc = [[Fast, feature-rich language support for Python]],
    homepage = "https://github.com/microsoft/pylance",
    languages = { Pkg.Lang.Python },
    categories = { Pkg.Cat.LSP },
    install = installer,
}
