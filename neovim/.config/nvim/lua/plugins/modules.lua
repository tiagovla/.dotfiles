return {
    { "nvim-tree/nvim-web-devicons", opts = { default = true } },
    { "famiu/bufdelete.nvim", event = "VeryLazy" },
    { "krady21/compiler-explorer.nvim", event = "VeryLazy" },
    {
        "tiagovla/scope.nvim",
        event = "BufRead",
        config = function()
            require("scope").setup { restore_state = true }
            vim.keymap.set({ "n", "o", "x" }, "<c-w>T", function()
                local old_tab = vim.api.nvim_get_current_tabpage()
                local buf = vim.api.nvim_get_current_buf()
                vim.cmd [[execute "normal! \<C-W>T"]]
                local new_tab = vim.api.nvim_get_current_tabpage()
                if old_tab ~= new_tab then
                    local cache = require("scope.core").cache
                    cache[old_tab] = vim.tbl_filter(function(e)
                        return e ~= buf
                    end, cache[old_tab])
                end
            end, { desc = "move into new tab", remap = true })
        end,
        dev = true,
    },
    { "tiagovla/buffercd.nvim", event = "BufRead", config = true },
    { "tiagovla/tex-conceal.vim", ft = "tex" },
    {
        "tiagovla/projet.nvim",
        config = function()
            require("projet").setup {}
            vim.keymap.set("n", "<leader>tp", "<cmd>Telescope projet<cr>", { desc = "Projects" })
            vim.keymap.set("n", "<leader>tP", function()
                require("projet").toggle_editor()
            end, { desc = "Project files" })
        end,
        dev = true,
        event = "VeryLazy",
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = false,
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {},
    },
    {
        "yioneko/nvim-type-fmt",
        lazy = false,
        config = function()
            require("type-fmt").setup {}
        end,
    },

    {
        "mfussenegger/nvim-lint",
        lazy = false,

        config = function()
            local lint = require "lint"
            lint.linters_by_ft = {
                ["cpp"] = { "cppcheck" },
                ["hpp"] = { "cppcheck" },
            }
            lint.linters.cppcheck.args[#lint.linters.cppcheck.args + 1] = "--check-level=exhaustive"
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
}
