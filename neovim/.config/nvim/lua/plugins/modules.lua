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
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup {}
            vim.keymap.set("n", "<leader>o", function()
                if vim.bo.filetype == "oil" then
                    require("oil").close()
                else
                    require("oil").open()
                end
            end, { desc = "File navigation" })
        end,
        lazy = false,
    },
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            require("chatgpt").setup {
                actions_paths = { vim.fs.joinpath(vim.fn.stdpath "config", "actions.json") },
            }
        end,
        init = function()
            vim.keymap.set("n", "<leader>cr", "vip:ChatGPTRun rewrite<cr>", { desc = "chatGPT rewrite" })
            vim.keymap.set(
                "n",
                "<leader>cR",
                "vip:ChatGPTRun rewrite_academic<cr>",
                { desc = "chatGPT rewrite academic" }
            )
            vim.keymap.set("v", "<leader>cR", ":ChatGPTRun rewrite<cr>", { desc = "chatGPT rewrite" })
            vim.keymap.set("v", "<leader>cr", ":ChatGPTRun rewrite_academic<cr>", { desc = "chatGPT rewrite academic" })
            vim.keymap.set("v", "<leader>cd", ":ChatGPTRun doit<cr>", { desc = "chatGPT do it" })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            messages = {
                enabled = true,
                view = "notify",
            },
            notify = {
                enabled = true,
                view = "mini",
            },
            cmdline = {
                view = "cmdline",
                format = {
                    cmdline = false,
                    -- search_down = false,
                    -- search_up = false,
                    -- filter = false,
                    help = false,
                    lua = false,
                },
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- "rcarriga/nvim-notify",
        },
    },
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>e", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" } },
        config = true,
        init = function()
            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match "Trouble" ~= nil then
                        vim.cmd.quit()
                    end
                end,
            })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        lazy = false,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
            }
        end,
        config = function(_, opts)
            vim.g.navic_silence = true
            require("nvim-navic").setup(opts)
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
    },
}

-- Add this:
-- https://github.com/3rd/image.nvim
