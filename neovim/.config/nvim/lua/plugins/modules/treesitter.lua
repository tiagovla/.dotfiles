local M = {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "nvim-treesitter/playground" },
        {
            "nvim-treesitter/nvim-treesitter-context",
            config = function(_, opts)
                require("treesitter-context").setup(opts)
            end,
            opts = {
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
            },
        },
        {
            "windwp/nvim-ts-autotag",
            lazy = false,
            opts = {
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
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
        ensure_installed = "all",
        ignore_install = { "comment" },
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
                node_incremental = "gnn",
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
    },
}

return M
