local M = { "aserowy/tmux.nvim", event = "VeryLazy" }

function M.config()
    require("tmux").setup {
        copy_sync = {
            enable = true,
        },
        navigation = {
            enable_default_keybindings = true,
        },
        resize = {
            enable_default_keybindings = true,
        },
    }
end

return M
