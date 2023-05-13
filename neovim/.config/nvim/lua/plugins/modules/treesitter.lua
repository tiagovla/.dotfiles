local M = {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "nvim-treesitter/playground" },
        {
            "simrat39/symbols-outline.nvim",
            config = function()
                require("symbols-outline").setup {}
            end,
        },
    },
}

function M.init()
    vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<cr>", { desc = "Symbols Outline" })
end

function M.config()
    local treesitter = require "nvim-treesitter.configs"
    treesitter.setup {
        ensure_installed = "all",
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            use_languagetree = false,
            disable = function(_, bufnr)
                local buf_name = vim.api.nvim_buf_get_name(bufnr)
                local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
                return file_size > 256 * 1024
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_umental = "gnn",
                scope_incremental = "gns",
                node_decremental = "gnp",
            },
        },
        context_commentstring = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["iB"] = "@block.inner",
                    ["aB"] = "@block.outer",
                    ["iF"] = "@frame.inner",
                    ["aF"] = "@frame.outer",
                },
            },
            swap = {
                enable = true,
                disable = { "lua" },
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]]"] = "@function.outer",
                },
                goto_next_end = {
                    ["]["] = "@function.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                },
            },
        },
    }
end

return M
