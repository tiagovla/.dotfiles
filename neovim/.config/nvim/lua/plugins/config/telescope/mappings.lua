local keymap = vim.keymap
keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>tg", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>tb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>th", "<cmd>Telescope help_tags<cr>")
keymap.set("n", "<leader>tc", "<cmd>Telescope colorscheme<cr>")
keymap.set("n", "<leader>tp", "<cmd>Telescope project<cr>")
