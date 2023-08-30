return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup {
            background_colour = "#212234",
            stages = "fade_in_slide_out",
            on_open = nil,
            on_close = nil,
            render = "minimal",
            timeout = 3000,
            minimum_width = 20,
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "✎",
            },
        }
        require("telescope").load_extension "notify"
        vim.notify = require "notify"
    end,
}
