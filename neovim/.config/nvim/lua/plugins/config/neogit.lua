local keymap = vim.keymap
keymap.set("n", "<space>n", "<cmd>Neogit<CR>")

return {
    config = function()
        require("neogit").setup()
    end,
}
