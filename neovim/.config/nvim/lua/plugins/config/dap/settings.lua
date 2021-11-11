local dap = require "dap"
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

dap.adapters.python = {
    type = "executable",
    command = os.getenv "HOME" .. "/.virtualenvs/debugpy/bin/python",
    args = { "-m", "debugpy.adapter" },
}

local get_python_path = function()
    local venv_path = os.getenv "VIRTUAL_ENV"
    if venv_path then
        return venv_path .. "/bin/python"
    end
    return nil
end

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",

        program = "${file}",
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.glob(cwd .. "/poetry.lock") then
                local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
                return venv .. "/bin" .. "/python"
            end
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
            elseif vim.fn.exists "$VIRTUAL_ENV" then
                return get_python_path()
            else
                return "/usr/bin/python"
            end
        end,
    },
}
