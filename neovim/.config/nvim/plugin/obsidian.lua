vim.pack.add {
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/epwalsh/obsidian.nvim" },
}

require("obsidian").setup {
    workspaces = {
        {
            name = "tiagovla",
            path = vim.fn.expand "~/.obsidian/tiagovla",
        },
    },
}
