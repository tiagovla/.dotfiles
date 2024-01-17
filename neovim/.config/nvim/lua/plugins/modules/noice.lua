return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        routes = {
            {
                view = "popup",
                filter = { event = "msg_show", cmdline = true, min_height = 2 },
            },
            {
                view = "popup",
                filter = { event = "msg_show", min_height = 20 },
            },
        },
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
        },
        notify = {
            enabled = true,
            view = "mini",
        },
        cmdline = {
            view = "cmdline",
            format = {
                cmdline = false,
                -- search_down = false,
                -- search_up = false,
                -- filter = false,
                help = false,
                lua = false,
            },
        },
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
}
