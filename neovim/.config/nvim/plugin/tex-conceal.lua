vim.pack.add(
    { "https://github.com/pxwg/math-conceal.nvim", "https://github.com/KeitaNakamura/tex-conceal.vim" },
    { confirm = false }
)

require("math-conceal").setup {}
