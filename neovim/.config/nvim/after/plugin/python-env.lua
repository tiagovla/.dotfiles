local utils = require "tiagovla.utils"

local function get_std_envs(workspace)
    local envs = {}
    if vim.env.VIRTUAL_ENV then
        envs["VIRTUAL_ENV"] = table.concat({ vim.env.VIRTUAL_ENV, "bin", "python" }, "/")
    end
    local sys = utils.get_python_executable() or "/bin/python"
    envs["System"] = sys
    if workspace then
        for _, name in ipairs { ".venv", "venv" } do
            local python = vim.fs.joinpath(workspace, name, "bin", "python")
            if vim.fn.executable(python) == 1 then
                envs[name] = python
            end
        end
    end
    return envs
end

local function get_poetry_envs(workspace)
    local envs = {}
    if not workspace or vim.fn.filereadable(vim.fs.joinpath(workspace, "poetry.lock")) ~= 1 then
        return envs
    end
    local ok, result = pcall(function()
        return vim.system({ "poetry", "env", "list", "--full-path" }, { cwd = workspace, text = true }):wait()
    end)
    if not ok or result.code ~= 0 then
        return envs
    end
    for _, line in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
        local venv = line:gsub("%s+%(Activated%)$", "")
        local python = vim.fs.joinpath(venv, "bin", "python")
        if vim.fn.executable(python) == 1 then
            envs["Poetry: " .. vim.fs.basename(venv)] = python
        end
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
    local workspace = client.config.root_dir
    local options = vim.tbl_extend("force", get_std_envs(workspace), get_poetry_envs(workspace))
    local active = utils.get_python_path(workspace)
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
            utils.set_python_path(client, options[selected])
        end
    end)
end

vim.api.nvim_create_user_command("PythonEnv", env_handler, {})
