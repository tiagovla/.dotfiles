local M = {
    "rcarriga/neotest",
    dependencies = {
        { "antoinemadec/FixCursorHold.nvim" },
        { "rcarriga/neotest-python" },
    },
    event = "VeryLazy",
}

function M.config()
    require("neotest").setup {
        status = {
            enabled = true,
            signs = true,
            virtual_text = false,
        },
        adapters = {
            require "neotest-python" {},
        },
    }
end

return M
