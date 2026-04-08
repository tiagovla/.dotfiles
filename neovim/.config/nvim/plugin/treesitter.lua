vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd "nvim-treesitter"
            end
            vim.cmd "TSUpdate"
        end
    end,
})

local ts = require "nvim-treesitter"

ts.setup {
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
}
local ensure_installed = ts.get_available()
local installed = ts.get_installed()

for i, lang in ipairs(ensure_installed) do
    if not vim.tbl_contains(installed, lang) then
        vim.defer_fn(function()
            ts.install(lang)
        end, i * 50)
    end
end
