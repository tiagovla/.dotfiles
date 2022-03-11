local keymap = vim.keymap
keymap.set("n", "<space>N", "<cmd>Neogit<CR>")
keymap.set("n", "<space>n", function()
    require("neogit").open { "commit" }
end)

return {
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
