vim.pack.add({ "https://github.com/SmiteshP/nvim-navic" }, { confirm = false })

vim.g.navic_silence = true

require("nvim-navic").setup {
    separator = " ",
    highlight = true,
    depth_limit = 5,
}
