local keymap = vim.keymap
keymap.set("n", "<space>gd", "<cmd>DogeGenerate<cr>")

return {
    cmd = "DogeGenerate",
    config = function()
        vim.g.doge_doc_standard_python = "numpy"
    end,
}
