vim.pack.add({ "https://github.com/tiagovla/tokyodark.nvim" }, { confirm = false })

require("tokyodark").setup {
    custom_highlights = function()
        return {
            GitConflictCurrent = { link = "DiffText" },
            GitConflictIncoming = { link = "DiffAdd" },
            GitConflictAncestor = { link = "DiffChange" },
            GitConflictCurrentLabel = { link = "DiffText" },
            GitConflictIncomingLabel = { link = "DiffAdd" },
            GitConflictAncestorLabel = { link = "DiffChange" },
        }
    end,
}
require("tokyodark").colorscheme()

vim.defer_fn(function()
    vim.cmd.colorscheme "tokyodark"
end, 200)
