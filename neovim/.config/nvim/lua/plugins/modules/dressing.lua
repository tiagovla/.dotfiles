return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
            win_options = {
                winblend = 0,
            },
        },
        select = {
            backend = { "fzf_lua", "fzf", "builtin", "nui" },
            nui = {
                win_options = {
                    winblend = 0,
                },
            },
            builtin = {
                win_options = {
                    winblend = 0,
                },
            },
        },
    },
}
