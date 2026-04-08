-- local Pkg = require "mason-core.package"
-- local configs = require "lspconfig.configs"
-- local lsp_util = require "vim.lsp.util"
-- local path = require "mason-core.path"
-- local util = require "lspconfig.util"
-- --
-- --
-- local root_files = {
--     "pyproject.toml",
--     "setup.py",
--     "setup.cfg",
--     "requirements.txt",
--     "Pipfile",
--     "pyrightconfig.json",
-- }
--
-- local function extract_method()
--     local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
--     local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
--     local params = {
--         command = "pylance.extractMethod",
--         arguments = arguments,
--     }
--     vim.lsp.buf.execute_command(params)
-- end
--
-- local function extract_variable()
--     local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
--     local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
--     local params = {
--         command = "pylance.extractVarible",
--         arguments = arguments,
--     }
--     vim.lsp.buf.execute_command(params)
-- end
--
-- local function organize_imports()
--     local params = {
--         command = "pyright.organizeimports",
--         arguments = { vim.uri_from_bufnr(0) },
--     }
--     vim.lsp.buf.execute_command(params)
-- end
--
-- local function on_workspace_executecommand(err, result, ctx)
--     if ctx.params.command:match "WithRename" then
--         ctx.params.command = ctx.params.command:gsub("WithRename", "")
--         vim.lsp.buf.execute_command(ctx.params)
--     end
--     if result then
--         if result.label == "Extract Method" then
--             local old_value = result.data.newSymbolName
--             local file = vim.tbl_keys(result.edits.changes)[1]
--             local range = result.edits.changes[file][1].range.start
--             local params = { textDocument = { uri = file }, position = range }
--             local client = vim.lsp.get_client_by_id(ctx.client_id)
--             local bufnr = ctx.bufnr
--             local prompt_opts = {
--                 prompt = "New Method Name: ",
--                 default = old_value,
--             }
--             if not old_value:find "new_var" then
--                 range.character = range.character + 5
--             end
--             vim.ui.input(prompt_opts, function(input)
--                 if not input or #input == 0 then
--                     return
--                 end
--                 params.newName = input
--                 local handler = client.handlers["textDocument/rename"] or vim.lsp.handlers["textDocument/rename"]
--                 client.request("textDocument/rename", params, handler, bufnr)
--             end)
--         end
--     end
-- end
--
-- return {
--     filetypes = { "python" },
--     root_dir = util.root_pattern(unpack(root_files)),
--     cmd = { "pylance", "--stdio" },
--     single_file_support = true,
--     capabilities = vim.lsp.protocol.make_client_capabilities(),
--     settings = {
--         editor = { formatOnType = true },
--         python = {
--             analysis = {
--                 -- ignore = { "*" },
--                 autoSearchPaths = false,
--                 useLibraryCodeForTypes = true,
--                 diagnosticMode = "workspace", --"workspace",
--                 typeCheckingMode = "off", -- "basic",
--                 completeFunctionParens = true,
--                 autoFormatStrings = true,
--                 -- logLevel = "Trace",
--                 -- logTypeEvaluationTime = true,
--                 -- minimumLoggingThreshold = 500,
--                 indexing = true,
--                 inlayHints = {
--                     variableTypes = true,
--                     functionReturnTypes = true,
--                     callArgumentNames = true,
--                     pytestParameters = true,
--                 },
--             },
--         },
--     },
--     handlers = {
--         ["workspace/executeCommand"] = on_workspace_executecommand,
--         ["textDocument/hover"] = function(_, result, ctx, config)
--             config = config or {}
--             if result.contents then
--                 result.contents.value = result.contents.value:gsub("<!--.*", "")
--             end
--             config.border = "single"
--             vim.lsp.handlers.hover(_, result, ctx, config)
--         end,
--     },
-- }
local function set_python_path(command)
    local path = command.args
    local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        name = "pylance",
    }
    for _, client in ipairs(clients) do
        if client.settings then
            client.settings.python =
                vim.tbl_deep_extend("force", client.settings.python --[[@as table]], { pythonPath = path })
        else
            client.config.settings =
                vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
        end
        client:notify("workspace/didChangeConfiguration", { settings = nil })
    end
end

return {
    cmd = { "pylance", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pylanceconfig.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
    },
    settings = {
        editor = { formatOnType = true },
        python = {
            analysis = {
                -- ignore = { "*" },
                autoSearchPaths = false,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", --"workspace",
                typeCheckingMode = "off", -- "basic",
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
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspPylanceOrganizeImports", function()
            local params = {
                command = "pylance.organizeimports",
                arguments = { vim.uri_from_bufnr(bufnr) },
            }
            client.request("workspace/executeCommand", params, nil, bufnr)
        end, {
            desc = "Organize Imports",
        })
        vim.api.nvim_buf_create_user_command(bufnr, "LspPylanceSetPythonPath", set_python_path, {
            desc = "Reconfigure pylance with the provided python path",
            nargs = 1,
            complete = "file",
        })
    end,
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
}
