vim.pack.add { "https://github.com/zbirenbaum/copilot.lua" }

vim.api.nvim_create_user_command("ToggleCopilot", function()
    require("copilot.suggestion").toggle_auto_trigger()
end, {})

require("copilot").setup {
    panel = {
        keymap = {
            jump_next = "<c-n>",
            jump_prev = "<c-p>",
            accept = "<CR>",
            refresh = "r",
            open = "<S-CR>",
        },
    },
    suggestion = {
        enable = true,
        auto_trigger = true,
        keymap = {
            -- next = "<c-n>",
            -- prev = "<c-p>",
            accept = "<C-CR>",
            dismiss = "<c-e>",
        },
    },
}
