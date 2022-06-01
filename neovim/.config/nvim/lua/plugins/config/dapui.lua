local function config()
    local ok, dap = pcall(require, "dap")

    if not ok then
        return
    end

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
        sidebar = {
            elements = {
                {
                    id = "scopes",
                    size = 0.25,
                },
                { id = "breakpoints", size = 0.25 },
                -- { id = "stacks", size = 0.25 },
                { id = "watches", size = 00.25 },
            },
            size = 50,
            position = "right", -- Can be "left", "right", "top", "bottom"
        },
        tray = {
            elements = {},
            -- elements = { "repl" },
            -- size = 10,
            -- position = "bottom", -- Can be "left", "right", "top", "bottom"
        },
        floating = {
            max_height = nil,
            max_width = nil,
            border = "rounded",
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
    }

    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

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

return {
    config = config,
}
