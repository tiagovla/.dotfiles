local keymap = vim.keymap

local keys = {
    ["db"] = "toggle_breakpoint",
    ["dB"] = "step_back",
    ["dc"] = "continue",
    ["dC"] = "run_to_cursor",
    ["dd"] = "disconnect",
    ["dS"] = "session",
    ["di"] = "step_into",
    ["do"] = "step_over",
    ["du"] = "step_out",
    ["dp"] = "pause.toggle",
    ["dr"] = "repl.toggle",
    ["ds"] = "continue",
    ["dq"] = "close",
}

for k, v in pairs(keys) do
    keymap.set("n", "<leader>" .. k, function()
        return require("dap")[v]()
    end)
end
