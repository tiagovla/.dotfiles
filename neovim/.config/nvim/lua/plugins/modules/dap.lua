local M = {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        { "theHamsta/nvim-dap-virtual-text" },
        { "rcarriga/nvim-dap-ui" },
    },
}

function M.init()
    local keys = {
        ["db"] = { "toggle_breakpoint", "Toggle breakpoint" },
        ["dB"] = { "step_back", "Step back" },
        ["dc"] = { "continue", "Continue" },
        ["dC"] = { "run_to_cursor", "Run to cursor" },
        ["dd"] = { "disconnect", "Disconnect" },
        ["dS"] = { "session", "Session" },
        ["di"] = { "step_into", "Setep into" },
        ["do"] = { "step_over", "Step over" },
        ["du"] = { "step_out", "Step out" },
        ["dp"] = { "pause.toggle", "Pause toggle" },
        -- ["dr"] = { "repl.open", "REPL toggle" },
        ["ds"] = { "continue", "Continue" },
        ["dq"] = { "close", "Close" },
    }
    for k, v in pairs(keys) do
        vim.keymap.set("n", "<leader>" .. k, function()
            return require("dap")[v[1]]()
        end, { desc = v[2] })
    end
    vim.keymap.set("n", "<leader>dr", function()
        return require("dap").repl.toggle()
    end, { desc = "REPL toggle" })
end

local function config_dap()
    local dap = require "dap"
    dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

    dap.adapters.python = {
        type = "executable",
        command = "debugpy-adapter",
    }

    dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "OpenDebugAD7",
    }

    local get_python_path = function()
        local venv_path = os.getenv "VIRTUAL_ENV"
        if venv_path then
            return venv_path .. "/bin/python"
        end
        return nil
    end

    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = true,
        },
    }

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
end

local function config_dap_ui()
    local dap = require "dap"
    local dapui = require "dapui"
    dapui.setup {
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        layouts = {
            {
                elements = {
                    "scopes",
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 40,
                position = "right",
            },
            {
                elements = {
                    "repl",
                },
                size = 10,
                position = "bottom",
            },
        },
        floating = {
            max_height = nil,
            max_width = nil,
            border = "single",
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        vim.keymap.set("v", "K", [[<Cmd>lua require("dapui").eval()<CR>]], { buffer = 0 })
        vim.keymap.set("n", "K", [[<Cmd>lua require("dapui").eval()<CR>]], { buffer = 0 })
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

function M.config()
    config_dap()
    config_dap_ui()
    require("nvim-dap-virtual-text").setup()
end

return M
