vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/neogitorg/neogit" }, { confirm = false })

require("neogit").setup {
    disable_commit_confirmation = true,
    sections = {
        staged = {
            folded = false,
            hidden = false,
        },
        untracked = {
            folded = true,
            hidden = false,
        },
        unstaged = {
            folded = true,
            hidden = false,
        },
    },
}

vim.keymap.set("n", "<space>N", function()
    require("neogit").open()
end, { desc = "Neogit" })

vim.keymap.set("n", "<space>n", function()
    require("neogit").open { "commit" }
end, { desc = "Neogit commit" })

vim.api.nvim_create_autocmd("User", {
    pattern = "NeogitStatusRefreshed",
    callback = function()
        local ok, api = pcall(require, "nvim-tree.api")
        if ok then
            api.tree.reload()
        end
    end,
})
