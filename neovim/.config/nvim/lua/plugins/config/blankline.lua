return {
    config = function()
        require("indent_blankline").setup {
            char = "▏",
            buftype_exclude = { "terminal" },
        }
    end,
}
