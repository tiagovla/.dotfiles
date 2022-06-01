local function mappings()
    vim.api.nvim_set_keymap("n", "<leader>gh", "<cmd>ISwapCursorNodeLeft<CR>", {})
    vim.api.nvim_set_keymap("n", "<leader>gl", "<cmd>ISwapCursorNodeRight<CR>", {})
end

local function config()
    require("iswap").setup {
        grey = "disable",
        keys = "qwertyuiop",
        hl_snipe = "ErrorMsg",
        hl_selection = "WarningMsg",
        hl_grey = "LineNr",
        autoswap = true,
        debug = nil,
        hl_grey_priority = "1000",
    }
end

mappings()
return {
    config = config,
}
