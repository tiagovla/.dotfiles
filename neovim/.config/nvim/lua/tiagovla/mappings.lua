local keymap = vim.keymap
local M = {}

function M.setup()
    M.general()
    M.movements()
end

function M.general()
    vim.g.mapleader = " "
    keymap.set("n", "n", "nzzzv")
    keymap.set("n", "N", "Nzzzv")
    keymap.set("n", "G", "Gzzzv")
    keymap.set("n", "J", "mzJ`z")
    keymap.set("i", ",", ",<c-g>u")
    keymap.set("i", ".", ".<c-g>u")
    keymap.set("i", "!", "!<c-g>u")
    keymap.set("i", "?", "?<c-g>u")
    keymap.set("v", "J", ":m .+1<cr>gv=gv", { silent = true })
    keymap.set("v", "K", ":m .-2<cr>gv=gv", { silent = true })
    keymap.set("n", "<leader>q", ":bp | sp | bn | bd<cr>", { silent = true })
    keymap.set("n", "<leader>Q", ":%bd|e#<cr>", { silent = true })
    keymap.set("n", "<Tab>", ":b#<cr>", { silent = true })
end

function M.movements()
    keymap.set("n", "<C-J>", "<C-W><C-J>")
    keymap.set("n", "<C-K>", "<C-W><C-K>")
    keymap.set("n", "<C-L>", "<C-W><C-L>")
    keymap.set("n", "<c-H>", "<C-W><C-H>")
    keymap.set({ "i", "v" }, "<C-J>", "<Esc><C-W><C-J>")
    keymap.set({ "i", "v" }, "<C-K>", "<Esc><C-W><C-K>")
    keymap.set({ "i", "v" }, "<C-L>", "<Esc><C-W><C-L>")
    keymap.set({ "i", "v" }, "<c-H>", "<Esc><C-W><C-H>")
    keymap.set("n", "<c-N>", "<cmd>BufferLineCycleNext<cr>")
    keymap.set("n", "<c-P>", "<cmd>BufferLineCyclePrev<cr>")
    keymap.set("n", "H", "gT")
    keymap.set("n", "L", "gt")
end

M.setup()
