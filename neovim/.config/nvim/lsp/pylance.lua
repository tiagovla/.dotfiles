local utils = require "tiagovla.utils"

local function set_python_path(command)
    local path = command.args
    local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        name = "pylance",
    }
    for _, client in ipairs(clients) do
        utils.set_python_path(client, path)
    end
end

return {
    cmd = { "pylance", "--stdio" },
    filetypes = { "python" },
    root_markers = utils.python_root_markers,
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
            client:request("workspace/executeCommand", params, nil, bufnr)
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
        client.config.settings.python.pythonPath = utils.get_python_path(client.config.root_dir)
    end,
}
