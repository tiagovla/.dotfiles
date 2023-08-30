return {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        enabled = true,
    },
    keys = {
        { "<leader>gd", "<cmd>Neogen<cr>", desc = "Neogen" },
    },
}
