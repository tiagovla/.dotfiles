local keymap = vim.keymap
keymap.set("n", "<space>gn", "<cmd>NeoGit<CR>")

return {
    config = function()
        require("neogit").setup()
    end,
}
