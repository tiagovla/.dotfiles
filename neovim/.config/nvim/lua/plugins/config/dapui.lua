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

    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })

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
