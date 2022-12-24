local M = { "zbirenbaum/copilot.lua", event = "VeryLazy" }

function M.config()
    vim.api.nvim_create_user_command("ToggleCopilot", require("copilot.suggestion").toggle_auto_trigger, {})
    require("copilot").setup {
        suggestion = {
            keymap = {
                next = "C-n",
                prev = "C-p",
                accept = "<C-]>",
                dismiss = "<C-e>",
            },
        },
    }
end

return M
