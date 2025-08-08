return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    opts = {
        actions_paths = { vim.fs.joinpath(vim.fn.stdpath "config", "actions.json") },
    },
    init = function()
        vim.keymap.set("n", "<leader>cr", "vip:ChatGPTRun rewrite<cr>", { desc = "chatGPT rewrite" })
        vim.keymap.set("n", "<leader>cR", "vip:ChatGPTRun rewrite_academic<cr>", { desc = "chatGPT rewrite academic" })
        vim.keymap.set("v", "<leader>cR", ":ChatGPTRun rewrite<cr>", { desc = "chatGPT rewrite" })
        vim.keymap.set("v", "<leader>cr", ":ChatGPTRun rewrite_academic<cr>", { desc = "chatGPT rewrite academic" })
        vim.keymap.set("v", "<leader>cd", ":ChatGPTRun doit<cr>", { desc = "chatGPT do it" })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
