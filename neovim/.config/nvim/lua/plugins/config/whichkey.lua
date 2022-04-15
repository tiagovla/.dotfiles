local function config()
    require("which-key").setup {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = false,
                suggestions = 20,
            },
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        operators = { gc = "Comments" },
        key_labels = {},
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
        },
        window = {
            border = "none",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 2, 2, 2, 2 },
        },
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left",
        },
        ignore_missing = false,
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
        show_help = true,
        triggers = "auto",
        triggers_blacklist = {
            i = { "j", "k" },
            v = { "j", "k" },
        },
    }
    local wk = require "which-key"
    wk.register({
        d = { "Dap Debugger" },
        g = { "General" },
        h = { "Git Signs" },
        t = { "Telescope" },
    }, {
        prefix = "<Space>",
    })
end

return {
    opt = true,
    setup = function()
        vim.defer_fn(function()
            require("packer").loader "which-key.nvim"
        end, 200)
    end,
    config = config,
}
