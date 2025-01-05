local M = {
    "folke/which-key.nvim",
    event = "VeryLazy",
}

function M.config()
    require("which-key").setup {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = false,
            },
            presets = {
                operators = false,
                motions = false,
                text_objects = false,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
        },
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left",
        },
    }
    local wk = require "which-key"
    wk.add({
        { "<leader>d", group = "Dap Debugger" },
        { "<leader>g", group = "General" },
        { "<leader>h", group = "Git Signs" },
        { "<leader>t", group = "Telescope" },
    }, {})
end

return M
