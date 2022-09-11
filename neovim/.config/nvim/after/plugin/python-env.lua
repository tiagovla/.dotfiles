local function get_std_envs()
    local envs = {}
    if vim.env.VIRTUAL_ENV then
        envs["VIRTUAL_ENV"] = table.concat({ vim.env.VIRTUAL_ENV, "bin", "python" }, "/")
    end
    local sys = vim.fn.exepath "python3" or vim.fn.exepath "python" or "/bin/python"
    envs["System"] = sys
    return envs
end

local function get_poetry_envs()
    local envs = {}
    local venv = vim.fn.trim(vim.fn.system "poetry env list --full-path")
    for match in string.gmatch(venv, "[%w%/%.%-]*virtualenv[%w%/%.%-]*") do
        local split = vim.fn.split(match, "/")
        envs["Poetry: " .. split[#split]] = table.concat({ match, "bin", "python" }, "/")
    end
    return envs
end

local function get_python_client()
    local pylance = vim.lsp.get_active_clients { name = "pylance" }
    local pyright = vim.lsp.get_active_clients { name = "pyright" }
    local clients = vim.tbl_extend("force", pylance, pyright)
    if #clients > 0 then
        return clients[1]
    end
end

local function env_handler()
    local client = get_python_client()
    if not client then
        vim.notify "No python clients found"
    end
    local options = vim.tbl_extend("force", get_std_envs(), get_poetry_envs())
    local settings = client.config.settings
    local active = settings.python.pythonPath
    vim.ui.select(vim.tbl_keys(options), {
        prompt = "Select a Python Enviroment:",
        format_item = function(item)
            if options[item] == active then
                return item .. " (Active)"
            end
            return item
        end,
    }, function(selected)
        if selected then
            settings.python.pythonPath = options[selected]
            client.notify("workspace/didChangeConfiguration", { settings = settings })
        end
    end)
end

vim.api.nvim_create_user_command("PythonEnv", env_handler, {})
