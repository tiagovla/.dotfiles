vim.keymap.set({ "n", "v" }, "<F2>", [[:TermExec cmd="!!"<CR>]])
vim.keymap.set({ "n", "v" }, "<F3>", [[:TermExec cmd="poetry run pytest"<CR>]])
