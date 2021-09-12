local ezmap = require("ezmap")

local dap_mappings = {
    {"n", "<space>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>"},
    {"n", "<space>dB", "<cmd>lua require'dap'.step_back()<cr>"},
    {"n", "<space>dc", "<cmd>lua require'dap'.continue()<cr>"},
    {"n", "<space>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>"},
    {"n", "<space>dd", "<cmd>lua require'dap'.disconnect()<cr>"},
    {"n", "<space>dS", "<cmd>lua require'dap'.session()<cr>"},
    {"n", "<space>di", "<cmd>lua require'dap'.step_into()<cr>"},
    {"n", "<space>do", "<cmd>lua require'dap'.step_over()<cr>"},
    {"n", "<space>du", "<cmd>lua require'dap'.step_out()<cr>"},
    {"n", "<space>dp", "<cmd>lua require'dap'.pause.toggle()<cr>"},
    {"n", "<space>dr", "<cmd>lua require'dap'.repl.toggle()<cr>"},
    {"n", "<space>ds", "<cmd>lua require'dap'.continue()<cr>"},
    {"n", "<space>dq", "<cmd>lua require'dap'.close()<cr>"}
}

ezmap.map(dap_mappings, {"noremap", "silent"})
