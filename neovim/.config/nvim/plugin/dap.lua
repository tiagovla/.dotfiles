vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
}, { confirm = false })

local utils = require "tiagovla.utils"

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
    ["dp"] = { "pause", "Pause" },
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

-- config DAP
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
            local clients = vim.lsp.get_clients { bufnr = 0 }
            for _, client in ipairs(clients) do
                if client.name == "pylance" or client.name == "pyright" then
                    return utils.get_python_path(client.config.root_dir)
                end
            end
            return utils.get_python_path()
        end,
    },
}

-- config DAP UI
local dapui = require "dapui"
local dapui_config = {
    icons = { expanded = "▾", collapsed = "▸", current_frame = "" },
    mappings = {
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
dapui.setup(dapui_config)

vim.keymap.set({ "n", "x" }, "<leader>de", function()
    dapui.eval()
end, { desc = "Evaluate expression" })

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("nvim-dap-virtual-text").setup {}
