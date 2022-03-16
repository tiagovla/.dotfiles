local keymap = vim.keymap

keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>")
keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>")
keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>")
keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>")
keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>")
keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>")
keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>")

return {
    config = function()
        require("bufferline").setup {
            options = {
                view = "multiwindow",
                numbers = function(opts)
                    return string.format("%s", opts.ordinal)
                end,
                modified_icon = "●",
                max_prefix_length = 5,
                tab_size = 18,
                diagnostics = "nvim_lsp",
                separator_style = { "|", "" },
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                    },
                },
            },
        }
    end,
}
