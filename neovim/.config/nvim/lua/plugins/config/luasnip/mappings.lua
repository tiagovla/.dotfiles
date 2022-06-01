local map = vim.keymap.set

map("i", "<c-u>", require "luasnip.extras.select_choice")
map({ "i", "s" }, "<C-n>", "<Plug>luasnip-next-choice", {})
map({ "i", "s" }, "<C-p>", "<Plug>luasnip-prev-choice", {})
