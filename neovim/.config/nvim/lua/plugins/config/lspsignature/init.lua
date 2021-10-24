return {
    config = function()
        require("lsp_signature").setup {
            bind = true,
            doc_lines = 2,
            floating_window = true,
            fix_pos = true,
            hint_scheme = "String",
            use_lspsaga = false,
            hi_parameter = "Search",
            max_height = 22,
            max_width = 120,
            handler_opts = { border = "single" },
            extra_trigger_chars = {},
            padding = "",
        }
    end,
}
