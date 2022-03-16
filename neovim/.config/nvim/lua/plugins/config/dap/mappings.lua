local keymap = vim.keymap

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
    ["dr"] = { "repl.toggle", "REPL toggle" },
    ["ds"] = { "continue", "Continue" },
    ["dq"] = { "close", "Close" },
}

for k, v in pairs(keys) do
    keymap.set("n", "<leader>" .. k, function()
        return require("dap")[v[1]]()
    end, { desc = v[2] })
end
