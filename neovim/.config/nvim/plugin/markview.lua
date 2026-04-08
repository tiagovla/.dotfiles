vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/OXY2DEV/markview.nvim",
}, { confirm = false })

require("markview").setup {
    experimental = {
        check_rtp_message = false,
    },
}
