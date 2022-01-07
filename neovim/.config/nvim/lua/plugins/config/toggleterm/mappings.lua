local keymap = vim.keymap

keymap.set("n", "<F1>", "<cmd>ToggleTerm<cr>")

function _G.set_terminal_keymaps()
    keymap.set("t", [[<F1>]], "<cmd>:ToggleTerm <cr>")
    keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]])
    keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]])
    keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]])
    keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]])
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
