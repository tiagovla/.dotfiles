vim.pack.add({
    "https://github.com/rcarriga/neotest",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/antoinemadec/FixCursorHold.nvim",
    "https://github.com/rcarriga/neotest-python",
    "https://github.com/rouge8/neotest-rust",
    "https://github.com/nvim-neotest/nvim-nio",
}, { confirm = false })

require("neotest").setup {
    status = {
        enabled = true,
        signs = true,
        virtual_text = false,
    },
    adapters = {
        require "neotest-python" {},
        require "neotest-rust" {
            args = { "--no-capture" },
            dap_adapter = "lldb",
        },
    },
}
