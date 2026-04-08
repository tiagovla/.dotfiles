vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/epwalsh/obsidian.nvim" },
}, { confirm = false })

local path = vim.fn.expand "~/.obsidian/tiagovla"

if vim.fn.isdirectory(path) == 1 then
    require("obsidian").setup {
        workspaces = {
            {
                name = "tiagovla",
                path = path,
            },
        },
    }
end
