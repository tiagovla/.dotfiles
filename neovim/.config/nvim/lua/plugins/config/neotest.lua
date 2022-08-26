local function config()
    require("neotest").setup {
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
