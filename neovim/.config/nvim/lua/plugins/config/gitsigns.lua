local function config()
    require("gitsigns").setup {
        signs = {
            add = { hl = "Green", text = "│" },
            change = { hl = "Blue", text = "│" },
            delete = { hl = "Red", text = "│" },
            topdelete = { hl = "Red", text = "-" },
            changedelete = { hl = "Red", text = "~" },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map("n", "]c", gs.next_hunk, { desc = "Next Hunk" })
            map("n", "[c", gs.prev_hunk, { desc = "Prev Hunk" })
            map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
            map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
            map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
            map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
            map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
            map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
            map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
            map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
        watch_gitdir = { interval = 1000 },
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil,
    }
end

return {
    event = "BufReadPre",
    requires = { "nvim-lua/plenary.nvim", opt = true },
    config = config,
}
