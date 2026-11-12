local utils = require "tiagovla.utils"

local function get_std_envs()
    local envs = {}
    if vim.env.VIRTUAL_ENV then
        envs["VIRTUAL_ENV"] = table.concat({ vim.env.VIRTUAL_ENV, "bin", "python" }, "/")
    end
    local sys = utils.get_python_executable() or "/bin/python"
    envs["System"] = sys
    return envs
end

local function get_poetry_envs(workspace)
    local envs = {}
    local ok, result = pcall(function()
        return vim.system({ "poetry", "env", "list", "--full-path" }, { cwd = workspace, text = true }):wait()
    end)
    if not ok or result.code ~= 0 then
        return envs
    end
    local venv = result.stdout
    for match in string.gmatch(venv, "[%w%/%.%-]*virtualenv[%w%/%.%-]*") do
        local split = vim.fn.split(match, "/")
        envs["Poetry: " .. split[#split]] = table.concat({ match, "bin", "python" }, "/")
    end
    return envs
end

local function get_python_client()
    local pylance = vim.lsp.get_clients { bufnr = 0, name = "pylance" }
    local pyright = vim.lsp.get_clients { bufnr = 0, name = "pyright" }
    return pylance[1] or pyright[1]
end

local function env_handler()
    local client = get_python_client()
    if not client then
        vim.notify "No python clients found"
        return
    end
    local options = vim.tbl_extend("force", get_std_envs(), get_poetry_envs(client.config.root_dir))
    local settings = client.config.settings
    local active = settings.python.pythonPath
    vim.ui.select(vim.tbl_keys(options), {
        prompt = "Select a Python Environment:",
        format_item = function(item)
            if options[item] == active then
                return item .. " (Active)"
            end
            return item
        end,
    }, function(selected)
        if selected then
            settings.python.pythonPath = options[selected]
            client:notify("workspace/didChangeConfiguration", { settings = settings })
        end
    end)
end

vim.api.nvim_create_user_command("PythonEnv", env_handler, {})
