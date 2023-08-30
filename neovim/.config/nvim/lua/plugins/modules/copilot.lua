return {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    init = function()
        vim.api.nvim_create_user_command("ToggleCopilot", function()
            require("copilot.suggestion").toggle_auto_trigger()
        end, {})
    end,
    opts = {
        suggestion = {
            keymap = {
                next = "C-n",
                prev = "C-p",
                accept = "<C-]>",
                dismiss = "<C-e>",
            },
        },
    },
}
