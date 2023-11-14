local Pkg = require "mason-core.package"
local configs = require "lspconfig.configs"
local lsp_util = require "vim.lsp.util"
local path = require "mason-core.path"
local util = require "lspconfig.util"

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

local function on_workspace_executecommand(err, result, ctx)
    if ctx.params.command:match "WithRename" then
        ctx.params.command = ctx.params.command:gsub("WithRename", "")
        vim.lsp.buf.execute_command(ctx.params)
    end
    if result then
        if result.label == "Extract Method" then
            local old_value = result.data.newSymbolName
            local file = vim.tbl_keys(result.edits.changes)[1]
            local range = result.edits.changes[file][1].range.start
            local params = { textDocument = { uri = file }, position = range }
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            local bufnr = ctx.bufnr
            local prompt_opts = {
                prompt = "New Method Name: ",
                default = old_value,
            }
            if not old_value:find "new_var" then
                range.character = range.character + 5
            end
            vim.ui.input(prompt_opts, function(input)
                if not input or #input == 0 then
                    return
                end
                params.newName = input
                local handler = client.handlers["textDocument/rename"] or vim.lsp.handlers["textDocument/rename"]
                client.request("textDocument/rename", params, handler, bufnr)
            end)
        end
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
                editor = { formatOnType = true },
                python = {
                    analysis = {
                        -- ignore = { "*" },
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace", --"workspace",
                        typeCheckingMode = "basic",
                        completeFunctionParens = true,
                        autoFormatStrings = true,
                        -- logLevel = "Trace",
                        -- logTypeEvaluationTime = true,
                        -- minimumLoggingThreshold = 500,
                        indexing = true,
                        inlayHints = {
                            variableTypes = true,
                            functionReturnTypes = true,
                            callArgumentNames = true,
                            pytestParameters = true,
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
    curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' > /dev/null &&
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
    ctx.spawn.bash {
        "-c",
        [[sed -i -E "s/;_0x[0-9a-f]+\['verifyClie'\+'nt'\]=function\(_0x[0-9a-f]+\)\{/&return;/" extension/dist/server.bundle.js]],
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
