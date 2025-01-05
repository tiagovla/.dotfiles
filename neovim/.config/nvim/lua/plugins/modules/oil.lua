return {
    "stevearc/oil.nvim",
    config = function()
        require("oil").setup {
            keymaps = {
                ["q"] = require("oil").close,
                ["-"] = require("oil").close,
            },
            cleanup_delay_ms = 500,
            float = {
                max_height = 20,
                max_width = 60,
            },
        }
        vim.keymap.set("n", "-", function()
            if vim.bo.filetype == "oil" then
                require("oil").close()
            else
                require("oil").open()
            end
        end, { desc = "File navigation" })
    end,
    lazy = false,
}
