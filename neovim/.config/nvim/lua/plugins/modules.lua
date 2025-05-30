return {
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup { default = true }
        end,
    },
    { "famiu/bufdelete.nvim", event = "VeryLazy" },
    { "krady21/compiler-explorer.nvim", event = "VeryLazy" },
    { "Almo7aya/openingh.nvim", event = "VeryLazy" },
    {
        "tiagovla/scope.nvim",
        event = "BufRead",
        config = function()
            require("scope").setup { restore_state = true }
            vim.keymap.set({ "n", "o", "x" }, "<c-w>T", function()
                local old_tab = vim.api.nvim_get_current_tabpage()
                local buf = vim.api.nvim_get_current_buf()
                vim.cmd [[execute "normal! \<C-W>T"]]
                local new_tab = vim.api.nvim_get_current_tabpage()
                if old_tab ~= new_tab then
                    local cache = require("scope.core").cache
                    cache[old_tab] = vim.tbl_filter(function(e)
                        return e ~= buf
                    end, cache[old_tab])
                end
            end, { desc = "move into new tab", remap = true })
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
    { "tiagovla/tex-conceal.vim", ft = "tex" },
    {
        "tiagovla/projet.nvim",
        config = function()
            require("projet").setup {}
            vim.keymap.set("n", "<leader>kk", function()
                require("projet").prompt()
            end, { desc = "Project files" })
            vim.keymap.set("n", "<leader>kl", function()
                require("projet").toggle_editor()
            end, { desc = "Project files" })
        end,
        dev = true,
        event = "VeryLazy",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup {
                enable = true,
                max_lines = 0,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = "outer",
                mode = "cursor",
                separator = nil,
                zindex = 20,
                on_attach = nil,
            }
        end,
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "windwp/nvim-ts-autotag",
        lazy = false,
        config = function()
            require("nvim-ts-autotag").setup {
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = false,
                    },
                },
            }
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

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = false,
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {},
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            gitbrowse = { enabled = true },
            bigfile = { enabled = true },
            -- notifier = { enabled = true },
            quickfile = { enabled = true },
            words = { enabled = true },
        },
    },
    {
        "yioneko/nvim-type-fmt",
        lazy = false,
        config = function()
            require("type-fmt").setup {}
        end,
    },

    {
        "mfussenegger/nvim-lint",
        lazy = false,

        config = function()
            local lint = require "lint"
            lint.linters_by_ft = {
                ["cpp"] = { "cppcheck" },
                ["hpp"] = { "cppcheck" },
            }
            lint.linters.cppcheck.args[#lint.linters.cppcheck.args + 1] = "--check-level=exhaustive"
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
