vim.pack.add({ "https://github.com/tiagovla/projet.nvim" }, { confirm = false })
require("projet").setup {}
vim.keymap.set("n", "<leader>tp", "<cmd>Telescope projet<cr>", { desc = "Projects" })
vim.keymap.set("n", "<leader>tP", function()
    require("projet").toggle_editor()
end, { desc = "Project files" })
