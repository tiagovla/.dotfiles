-- vim.opt_local.makeprg = "./make"
vim.opt_local.shiftwidth = 2
vim.opt_local.colorcolumn = "100"
vim.keymap.set({ "n", "v", "i" }, "<F2>", [[<cmd>make<cr>]])
