return {
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup { default = true }
        end,
    },
    { "krady21/compiler-explorer.nvim", event = "VeryLazy" },
    {
        "tiagovla/scope.nvim",
        event = "BufRead",
        config = function()
            require("scope").setup {}
        end,
    },
    {
        "tiagovla/buffercd.nvim",
        event = "BufRead",
        config = function()
            require("buffercd").setup {}
        end,
    },
    { "famiu/bufdelete.nvim", event = "VeryLazy" },
    { "tiagovla/tex-conceal.vim", ft = "tex" },
}
