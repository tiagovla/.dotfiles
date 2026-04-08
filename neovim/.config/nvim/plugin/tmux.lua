vim.pack.add { "https://github.com/aserowy/tmux.nvim" }

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
