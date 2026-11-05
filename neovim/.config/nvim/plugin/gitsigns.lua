vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
}, { confirm = false })

require("gitsigns").setup {
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "│" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function w(func)
            return function(...)
                local result = func(...)
                vim.defer_fn(function()
                    vim.cmd "NvimTreeRefresh"
                end, 50)
                return result
            end
        end

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, w(r), opts)
        end

        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal { "]c", bang = true }
            else
                gs.nav_hunk "next"
            end
        end, { desc = "Next Hunk" })
        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal { "[c", bang = true }
            else
                gs.nav_hunk "prev"
            end
        end, { desc = "Prev Hunk" })
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>hs", function()
            gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "Stage selected hunk" })
        map("v", "<leader>hr", function()
            gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "Reset selected hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hi", gs.preview_hunk_inline, { desc = "Preview hunk inline" })
        map("n", "<leader>hb", function()
            gs.blame_line { full = true }
        end, { desc = "Blame line" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function()
            gs.diffthis "~"
        end, { desc = "Diff against previous revision" })
        map("n", "<leader>hQ", function()
            gs.setqflist "all"
        end, { desc = "All hunks to quickfix" })
        map("n", "<leader>hq", gs.setqflist, { desc = "Hunks to quickfix" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
        map("n", "<leader>tw", gs.toggle_word_diff, { desc = "Toggle word diff" })
        map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Select hunk" })
    end,
    watch_gitdir = { interval = 1000 },
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil,
}
