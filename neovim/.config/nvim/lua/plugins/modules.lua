vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match "Trouble" ~= nil then
            vim.cmd.quit()
        end
    end,
})

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
        config = true,
        lazy = false,
    },

    -- {
    --     "echasnovski/mini.pairs",
    --     event = "VeryLazy",
    --     config = function()
    --         require("mini.pairs").setup()
    --     end,
    -- },
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
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = { { "<leader>e", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" } },
    },
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     opts = {},
    --     keys = {
    --         {
    --             "s",
    --             mode = { "n", "x", "o" },
    --             function()
    --                 -- default options: exact mode, multi window, all directions, with a backdrop
    --                 require("flash").jump()
    --             end,
    --             desc = "Flash",
    --         },
    --         {
    --             "S",
    --             mode = { "n", "o", "x" },
    --             function()
    --                 -- show labeled treesitter nodes around the cursor
    --                 require("flash").treesitter()
    --             end,
    --             desc = "Flash Treesitter",
    --         },
    --         {
    --             "r",
    --             mode = "o",
    --             function()
    --                 -- jump to a remote location to execute the operator
    --                 require("flash").remote()
    --             end,
    --             desc = "Remote Flash",
    --         },
    --         {
    --             "R",
    --             mode = { "n", "o", "x" },
    --             function()
    --                 -- show labeled treesitter nodes around the search matches
    --                 require("flash").treesitter_search()
    --             end,
    --             desc = "Treesitter Search",
    --         },
    --     },
    -- },
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
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
        lazy = false,
    },
}

-- vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(args)
--         local buffer = args.buf
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         local caps = client.server_capabilities
--
--         vim.bo[buffer].formatexpr = "" --  yikes
--
--         if caps.documentHighlightProvider then
--             local group = vim.api.nvim_create_augroup("DocumentHighlight", {})
--             vim.api.nvim_create_autocmd("CursorHold", {
--                 group = group,
--                 buffer = 0,
--                 callback = vim.lsp.buf.document_highlight,
--             })
--             vim.api.nvim_create_autocmd("CursorMoved", {
--                 group = group,
--                 buffer = 0,
--                 callback = vim.lsp.buf.clear_references,
--             })
--         end
--
--         if caps.documentFormattingProvider then
--             local group = vim.api.nvim_create_augroup("Formatting", {})
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = group,
--                 buffer = 0,
--                 callback = function()
--                     if vim.g.format_on_save then
--                         require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] = nil
--                         vim.lsp.buf.format {
--                             timeout_ms = 3000,
--                             filter = function(c)
--                                 return c.name == "null-ls" or c.name == "matlab_ls"
--                             end,
--                         }
--                     end
--                 end,
--             })
--         end
--     end,
-- })
