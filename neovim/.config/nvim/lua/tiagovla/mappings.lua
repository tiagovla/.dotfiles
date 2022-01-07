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
end

function M.movements()
    keymap.set("n", "<C-J>", "<C-W><C-J>")
    keymap.set("n", "<C-K>", "<C-W><C-K>")
    keymap.set("n", "<C-L>", "<C-W><C-L>")
    keymap.set("n", "<c-H>", "<C-W><C-H>")
    keymap.set("n", "<c-N>", ":bnext<cr>", { silent = true })
    keymap.set("n", "<c-P>", ":bprev<cr>", { silent = true })
    keymap.set("n", "H", "gt")
    keymap.set("n", "L", "gT")
end

M.setup()
