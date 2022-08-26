local keymap = vim.keymap

keymap.set("n", "<space>N", "<cmd>Neogit<CR>", { desc = "Neogit" })
keymap.set("n", "<space>n", function()
    require("neogit").open { "commit" }
end, { desc = "Neogit commit" })

return {
    module = "neogit",
    config = function()
        require("neogit").setup {
            disable_commit_confirmation = true,
            auto_refresh = true,
            integrations = {
                diffview = true,
            },
        }
    end,
}
