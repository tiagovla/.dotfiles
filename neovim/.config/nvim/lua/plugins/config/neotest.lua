local function config()
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

return {
    config = config,
    requires = {
        "antoinemadec/FixCursorHold.nvim",
        "rcarriga/neotest-python",
    },
}
