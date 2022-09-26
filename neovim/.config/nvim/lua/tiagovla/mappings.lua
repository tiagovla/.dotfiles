local map = vim.keymap.set
local utils = require "tiagovla.utils.buffers"
local M = {}

function M.setup()
    M.general()
    M.movements()
end

function M.general()
    vim.g.mapleader = " "
    map("n", "n", "nzzzv")
    map("n", "N", "Nzzzv")
    map("n", "G", "Gzzzv")
    map("n", "J", "mzJ`z")
    map("i", ",", ",<c-g>u")
    map("i", ".", ".<c-g>u")
    map("i", "!", "!<c-g>u")
    map("i", "?", "?<c-g>u")
    map("v", "J", ":m .+1<cr>gv=gv", { silent = true })
    map("v", "K", ":m .-2<cr>gv=gv", { silent = true })
    map("n", "<leader>s", ":vsplit<cr>", { silent = true, desc = "Vertical split" })
    map("n", "<leader>q", M.better_close, { desc = "Close buffer" })
    map("n", "<leader>Q", ":%bd|e#<cr>", { desc = "Close all other buffers" })
    map("n", "<Tab>", ":b#<cr>", { silent = true, desc = "Switch buffers" })
    map("n", "[q", ":cnext<cr>", { silent = true, desc = "Next item in quickfix list" })
    map("n", "]q", ":cprev<cr>", { silent = true, desc = "Previous item in quickfix list" })
    map("n", "<CR>", [[{-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()]], { silent = true, expr = true })
    map({ "n", "x", "o" }, "n", '"Nn"[v:searchforward]', { expr = true, desc = "Better forward N behaviour" })
    map({ "n", "x", "o" }, "N", '"nN"[v:searchforward]', { expr = true, desc = "Better backward N behaviour" })
    map("v", "<", "<gv", { desc = "Dedent current selection" })
    map("v", ">", ">gv", { desc = "Indent current selection" })
    map("n", "/", "ms/", { desc = "Keeps jumplist after forward searching" })
    map("n", "?", "ms?", { desc = "Keeps jumplist after backward searching" })
    map("n", "Q", "<Nop>", { desc = "Remove annoying exmode" })
    map("n", "q:", "<Nop>", { desc = "Remove annoying exmode" })
    map("n", "c", '"_c')
    map("n", "C", '"_C')
    map("n", "s", '"_s')
    map("n", "S", '"_S')
    map("n", "c_", '"_c^')
    map("n", "d_", '"_d^')
    map("n", "<C-Right>", ":vertical resize +2<CR>")
    map("n", "<C-Down>", ":resize +2<CR>")
    map("n", "<C-Up>", ":resize -2<CR>")
    map("n", "<C-Left>", ":vertical resize -2<CR>")
    map("v", "p", "p:let @+=@0<CR>")
    map("n", "gx", function()
        vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>", nil, nil) }, { detach = true })
    end, {})
    map("n", "<leader>w", [[<esc><cmd>call feedkeys("\<lt>c-w>")<cr>]], { silent = true })
end

function M.movements()
    map("n", "<C-J>", "<C-W><C-J>")
    map("n", "<C-K>", "<C-W><C-K>")
    map("n", "<C-L>", "<C-W><C-L>")
    map("n", "<c-H>", "<C-W><C-H>")
    map({ "i", "v" }, "<C-J>", "<Esc><C-W><C-J>")
    map({ "i", "v" }, "<C-K>", "<Esc><C-W><C-K>")
    map({ "i", "v" }, "<C-L>", "<Esc><C-W><C-L>")
    map({ "i", "v" }, "<c-H>", "<Esc><C-W><C-H>")
    map("n", "<c-N>", "<cmd>BufferLineCycleNext<cr>")
    map("n", "<c-P>", "<cmd>BufferLineCyclePrev<cr>")
    map("n", "H", "gT")
    map("n", "L", "gt")
    map({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    map("n", "#", M.better_hlsearch)
    map("n", "*", M.better_hlsearch)
end

function M.better_hlsearch()
    local current_word = vim.call("expand", "<cword>")
    vim.fn.setreg("/", "\\<" .. current_word .. "\\>")
    vim.api.nvim_command "set hlsearch"
end

function M.better_close()
    local tabpages = vim.api.nvim_list_tabpages()
    local buffers = utils.get_valid_buffers()
    local named_buffers = vim.tbl_filter(utils.has_name, buffers)
    if #tabpages > 1 and #named_buffers <= 1 then
        vim.cmd [[:tabclose]]
    elseif #named_buffers <= 1 then
        vim.cmd [[:q]]
        vim.cmd [[:q]]
    else
        vim.cmd [[:Bdelete]]
    end
end

M.setup()
