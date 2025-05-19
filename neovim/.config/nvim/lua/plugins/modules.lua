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
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end,
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        -- ft = "markdown" -- If you decide to lazy-load anyway

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
                    -- Defaults
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false, -- Auto close on trailing </
                },
                -- Also override individual filetype configs, these take priority.
                -- Empty by default, useful if one of the "opts" global settings
                -- doesn't work well in a specific filetype
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

    -- {
    --     "nvimdev/lspsaga.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("lspsaga").setup {}
    --     end,
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter", -- optional
    --         "nvim-tree/nvim-web-devicons", -- optional
    --     },
    -- },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = false,
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
            -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
    {
        "nvzone/menu",
        lazy = true,
        dependencies = {
            { "nvzone/volt", lazy = true },
            {
                "nvzone/minty",
                cmd = { "Shades", "Huefy" },
            },
        },
        init = function()
            vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
                require("menu.utils").delete_old_menus()

                vim.cmd.exec '"normal! \\<RightMouse>"'

                -- clicked buf
                local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
                local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

                require("menu").open(options, { mouse = true })
            end, {})
        end,
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
            require("type-fmt").setup {
                -- buf_filter = function(bufnr)
                --     return true
                -- end,
                -- prefer_client = function(client_a, client_b)
                --     return client_a or client_b
                -- end,
            }
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
            -- lint.linters.cppcheck.args[#lint.linters.cppcheck.args + 1] = "--inconclusive"
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
