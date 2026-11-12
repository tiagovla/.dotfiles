local U = {}
local python_paths = {}

U.python_root_markers = {
    "pylanceconfig.json",
    "uv.lock",
    "poetry.lock",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
}

function U.buf_is_valid(buf_num)
    if not buf_num or buf_num < 1 then
        return false
    end
    local exists = vim.api.nvim_buf_is_valid(buf_num)
    return vim.bo[buf_num].buflisted and exists
end

function U.get_valid_buffers()
    local buf_nums = vim.api.nvim_list_bufs()
    local ids = {}
    for _, buf in ipairs(buf_nums) do
        if U.buf_is_valid(buf) then
            ids[#ids + 1] = buf
        end
    end
    return ids
end

function U.buf_has_name(buf)
    return vim.api.nvim_buf_get_name(buf) ~= ""
end

function U.get_python_executable()
    local python = vim.fn.exepath "python3"
    if python == "" then
        python = vim.fn.exepath "python"
    end
    return python ~= "" and python or nil
end

function U.get_poetry_python(workspace)
    if not workspace or vim.fn.filereadable(vim.fs.joinpath(workspace, "poetry.lock")) ~= 1 then
        return nil
    end

    local ok, result = pcall(function()
        return vim.system({ "poetry", "env", "info", "-p" }, { cwd = workspace, text = true }):wait()
    end)
    if not ok or result.code ~= 0 then
        return nil
    end

    local venv = vim.trim(result.stdout)
    if venv == "" then
        return nil
    end
    local python = vim.fs.joinpath(venv, "bin", "python")
    return vim.fn.executable(python) == 1 and python or nil
end

function U.get_python_path(workspace)
    workspace = vim.fs.normalize(workspace or vim.fs.root(0, U.python_root_markers) or vim.fn.getcwd())
    if python_paths[workspace] and vim.fn.executable(python_paths[workspace]) == 1 then
        return python_paths[workspace]
    end
    if vim.env.VIRTUAL_ENV then
        local python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
        if vim.fn.executable(python) == 1 then
            return python
        end
    end
    for _, name in ipairs { ".venv", "venv" } do
        local python = vim.fs.joinpath(workspace, name, "bin", "python")
        if vim.fn.executable(python) == 1 then
            return python
        end
    end
    return U.get_poetry_python(workspace) or U.get_python_executable() or "python"
end

function U.set_python_path(client, path)
    local python = vim.fn.exepath(vim.fn.expand(path))
    if python == "" then
        vim.notify("Python executable not found: " .. path, vim.log.levels.ERROR)
        return
    end
    local workspace = vim.fs.normalize(client.config.root_dir or vim.fn.getcwd())
    python_paths[workspace] = python
    client.settings = client.settings or client.config.settings or {}
    client.settings.python = client.settings.python or {}
    client.settings.python.pythonPath = python
    client.config.settings = client.settings
    client:notify("workspace/didChangeConfiguration", { settings = client.settings })
end

-- function U.debug()
--     vim.cmd [[
--                 function! SynGroup()
--                     let l:s = synID(line('.'), col('.'), 1)
--                     echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
--                 endfun
--             ]]
--     vim.cmd [[nmap <F10> :call SynGroup() <cr>]]
-- end

return U
