local function config()
    require("gitsigns").setup {
        signs = {
            add = { hl = "Green", text = "│" },
            change = { hl = "Blue", text = "│" },
            delete = { hl = "Red", text = "│" },
            topdelete = { hl = "Red", text = "-" },
            changedelete = { hl = "Red", text = "~" },
        },
        numhl = false,
        linehl = false,
        keymaps = {
            buffer = true,
            noremap = true,
            ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
            ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
            ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
            ["n <leader>hS"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
            ["n <leader>hU"] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
        },
        watch_index = { interval = 1000 },
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil,
        use_decoration_api = false,
    }
end

return {
    event = "BufReadPre",
    requires = { "nvim-lua/plenary.nvim", opt = true },
    config = config,
}
