return {
    setup = function()
        vim.keymap.set("n", "<leader>gd", "<cmd>Neogen<cr>", { desc = "Neogen" })
    end,
    config = function()
        require("neogen").setup {
            enabled = true,
        }
    end,
    requires = "nvim-treesitter/nvim-treesitter",
}
