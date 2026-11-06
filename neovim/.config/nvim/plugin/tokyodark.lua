vim.pack.add({ "https://github.com/tiagovla/tokyodark.nvim" }, { confirm = false })

require("tokyodark").setup {}
require("tokyodark").colorscheme()

vim.defer_fn(function()
    vim.cmd.colorscheme "tokyodark"
end, 200)
