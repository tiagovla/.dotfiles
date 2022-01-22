local function config()
    require("notify").setup {
        stages = "fade_in_slide_out",
        on_open = nil,
        on_close = nil,
        render = "minimal",
        timeout = 3000,
        background_colour = "#212234",
        minimum_width = 20,
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },
    }
    vim.notify = require "notify"
end

return {
    config = config,
}
