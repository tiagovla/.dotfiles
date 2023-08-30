return {
    "rcarriga/neotest",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
        { "antoinemadec/FixCursorHold.nvim" },
        { "rcarriga/neotest-python" },
        { "rouge8/neotest-rust" },
    },
    ft = { "python" },
    opts = {
        status = {
            enabled = true,
            signs = true,
            virtual_text = false,
        },
    },
    config = function(_, opts)
        opts.adapters = {
            require "neotest-python" {},
            require "neotest-rust" {
                args = { "--no-capture" },
                dap_adapter = "lldb",
            },
        }
        require("neotest").setup { opts }
    end,
}
