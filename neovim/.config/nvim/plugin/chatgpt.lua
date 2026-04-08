vim.pack.add({
    "https://github.com/jackMort/ChatGPT.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
}, { confirm = false })

require("chatgpt").setup {
    actions_paths = { vim.fs.joinpath(vim.fn.stdpath "config", "actions.json") },
}

vim.keymap.set("n", "<leader>cr", "vip:ChatGPTRun rewrite<cr>", { desc = "chatGPT rewrite" })
vim.keymap.set("n", "<leader>cR", "vip:ChatGPTRun rewrite_academic<cr>", { desc = "chatGPT rewrite academic" })
vim.keymap.set("v", "<leader>cR", ":ChatGPTRun rewrite<cr>", { desc = "chatGPT rewrite" })
vim.keymap.set("v", "<leader>cr", ":ChatGPTRun rewrite_academic<cr>", { desc = "chatGPT rewrite academic" })
vim.keymap.set("v", "<leader>cd", ":ChatGPTRun doit<cr>", { desc = "chatGPT do it" })
