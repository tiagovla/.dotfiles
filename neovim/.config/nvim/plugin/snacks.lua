vim.pack.add({ "https://github.com/folke/snacks.nvim" }, { confirm = false })

require("snacks").setup {
    gitbrowse = { enabled = true },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
}
