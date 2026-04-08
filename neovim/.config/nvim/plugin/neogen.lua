vim.pack.add {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/danymat/neogen",
}

require("neogen").setup {
    enabled = true,
}

vim.keymap.set("n", "<leader>gd", "<cmd>Neogen<cr>", { desc = "Neogen" })
