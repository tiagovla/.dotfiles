local config = {
    options = {
        tools = {
            inlay_hints = {
                only_current_line = false,
                only_current_line_autocmd = "CursorHold",
                show_parameter_hints = true,
                show_variable_name = false,
                parameter_hints_prefix = "<- ",
                -- other_hints_prefix = "=> ",
                other_hints_prefix = "",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
            },
        },
    },
}

return config
