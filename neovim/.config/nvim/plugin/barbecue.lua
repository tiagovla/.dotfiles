vim.pack.add({
    "https://github.com/utilyre/barbecue.nvim",
    "https://github.com/SmiteshP/nvim-navic",
    "https://github.com/nvim-tree/nvim-web-devicons",
}, { confirm = false })

vim.g.navic_silence = true

require("barbecue").setup()

require("nvim-navic").setup {
    separator = " ",
    highlight = true,
    depth_limit = 5,
}
