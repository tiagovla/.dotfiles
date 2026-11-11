vim.pack.add({
    "https://github.com/rcarriga/neotest",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/antoinemadec/FixCursorHold.nvim",
    "https://github.com/rcarriga/neotest-python",
    "https://github.com/rouge8/neotest-rust",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/civitasv/cmake-tools.nvim",
    "https://github.com/tiagovla/neotest-gtest",
}, { confirm = false })

vim.opt.rtp:prepend(vim.fn.expand "~/git/neotest-gtest")

local neotest = require "neotest"
neotest.setup {
    status = {
        enabled = true,
        signs = true,
        virtual_text = false,
    },
    adapters = {
        require "neotest-python",
        require "neotest-rust" {
            args = { "--no-capture" },
            dap_adapter = "cppdbg",
        },
        require("neotest-gtest").setup {
            debug_adapter = "cppdbg",
        },
    },
}

vim.keymap.set("n", "<leader>ra", function()
    neotest.run.attach()
end, {
    desc = "Attach to Test (Neotest)",
})
vim.keymap.set("n", "<leader>rt", function()
    neotest.run.run(vim.fn.expand "%")
end, {
    desc = "Run File (Neotest)",
})
vim.keymap.set("n", "<leader>rT", function()
    neotest.run.run(vim.uv.cwd())
end, {
    desc = "Run All Test Files (Neotest)",
})
vim.keymap.set("n", "<leader>rr", function()
    neotest.run.run()
end, {
    desc = "Run Nearest (Neotest)",
})
vim.keymap.set("n", "<leader>rl", function()
    neotest.run.run_last()
end, {
    desc = "Run Last (Neotest)",
})
vim.keymap.set("n", "<leader>rs", function()
    neotest.summary.toggle()
end, {
    desc = "Toggle Summary (Neotest)",
})
vim.keymap.set("n", "<leader>ro", function()
    neotest.output.open { enter = true, auto_close = true }
end, { desc = "Show Output (Neotest)" })
vim.keymap.set("n", "<leader>rO", function()
    neotest.output_panel.toggle()
end, {
    desc = "Toggle Output Panel (Neotest)",
})
vim.keymap.set("n", "<leader>rS", function()
    neotest.run.stop()
end, {
    desc = "Stop (Neotest)",
})
vim.keymap.set("n", "<leader>rw", function()
    neotest.watch.toggle(vim.fn.expand "%")
end, {
    desc = "Toggle Watch (Neotest)",
})

require("cmake-tools").setup {}
