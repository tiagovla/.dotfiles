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
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
        lazy = false,
    },
    {
        "ThePrimeagen/harpoon",
        lazy = false,
        config = function()
            local opts = { noremap = true, silent = true }
            for i = 1, 9 do
                vim.keymap.set("n", "<leader>" .. i, function()
                    require("harpoon.ui").nav_file(i)
                end, { desc = "Harpoon " .. i .. " file" })
            end
            vim.keymap.set("n", "<s-m>", function()
                require("harpoon.mark").add_file()
                vim.notify "󱡅  marked file"
            end, opts)
            vim.keymap.set("n", "<leader><Tab>", function()
                require("harpoon.ui").toggle_quick_menu()
            end, opts)
        end,
    },
    {
        "lowitea/aw-watcher.nvim",
        lazy = false,
        opts = {
            aw_server = {
                host = "127.0.0.1",
                port = 5600,
            },
        },
    },

-- Add this:
-- https://github.com/3rd/image.nvim
