return {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = "markdown",
    init = function()
        vim.api.nvim_create_user_command("Peek", function()
            local peek = require "peek"
            local toggle = peek.close and peek.is_open() or peek.open
            toggle()
        end, {})
    end,
    opts = { theme = "dark" },
}
