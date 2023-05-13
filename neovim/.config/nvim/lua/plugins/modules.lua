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
            require("scope").setup { restore_state = true }
        end,
        dev = true,
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
    {
        "tzachar/local-highlight.nvim",
        event = "VeryLazy",
        config = function()
            require("local-highlight").setup {
                file_types = { "python", "cpp", "lua" },
                hlgroup = "Visual",
            }
        end,
    },
    -- {
    --     "echasnovski/mini.pairs",
    --     event = "VeryLazy",
    --     config = function()
    --         require("mini.pairs").setup()
    --     end,
    -- },
}
