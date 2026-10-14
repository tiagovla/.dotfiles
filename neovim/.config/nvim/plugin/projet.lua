vim.pack.add({ "https://github.com/tiagovla/projet.nvim" }, { confirm = false })
require("projet").setup {
    mappings = {
        { "n", "q", require("projet.editor").close },
        { "n", "<ESC><ESC>", require("projet.editor").close },
        {
            "n",
            "<CR>",
            function()
                require("projet.editor").select(function(project)
                    vim.cmd("cd " .. project.path)
                end)
            end,
        },
    },
}

vim.keymap.set("n", "<leader>tp", "<cmd>Telescope projet<cr>", { desc = "Projects" })
vim.keymap.set("n", "<leader>tP", function()
    require("projet").toggle_editor()
end, { desc = "Project files" })
