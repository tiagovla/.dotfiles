local utils = require "tiagovla.utils"

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
        "uv.lock",
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
        client.config.settings.python.pythonPath = (function(workspace)
            if vim.env.VIRTUAL_ENV then
                return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if workspace then
                local poetry_lock_path = vim.fs.joinpath(workspace, "poetry.lock")
                if vim.fn.filereadable(poetry_lock_path) then
                    local python = utils.get_poetry_python(workspace)
                    if python then
                        return python
                    end
                end
                local uv_lock_path = vim.fs.joinpath(workspace, "uv.lock")
                local uv_python = vim.fs.joinpath(workspace, ".venv", "bin", "python")
                if vim.fn.filereadable(uv_lock_path) and vim.fn.executable(uv_python) == 1 then
                    return uv_python
                end
            end
            return utils.get_python_executable() or "python"
        end)(client.config.root_dir)
    end,
}
