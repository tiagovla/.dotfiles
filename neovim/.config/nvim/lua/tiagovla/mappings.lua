local keymap = vim.keymap
local utils = require "tiagovla.utils.buffers"
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
    keymap.set("n", "<leader>s", ":vsplit<cr>", { silent = true, desc = "Vertical split" })
    keymap.set("n", "<leader>q", M.do_close, { desc = "Close buffer" })
    keymap.set("n", "<leader>Q", ":%bd|e#<cr>", { desc = "Close all other buffers" })
    keymap.set("n", "<Tab>", ":b#<cr>", { silent = true, desc = "Switch buffers" })
    keymap.set("n", "[q", ":cnext<cr>", { silent = true, desc = "Next item in quickfix list" })
    keymap.set("n", "]q", ":cprev<cr>", { silent = true, desc = "Previous item in quickfix list" })
    keymap.set("n", "<CR>", [[{-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()]], { silent = true, expr = true })
    keymap.set({ "n", "x", "o" }, "n", '"Nn"[v:searchforward]', { expr = true, desc = "Better forward N behaviour" })
    keymap.set({ "n", "x", "o" }, "N", '"nN"[v:searchforward]', { expr = true, desc = "Better backward N behaviour" })
    keymap.set("v", "<", "<gv", { desc = "Dedent current selection" })
    keymap.set("v", ">", ">gv", { desc = "Indent current selection" })
    keymap.set("n", "/", "ms/", { desc = "Keeps jumplist after forward searching" })
    keymap.set("n", "?", "ms?", { desc = "Keeps jumplist after backward searching" })
    keymap.set("n", "Q", "<Nop>", { desc = "Remove annoying exmode" })
    keymap.set("n", "q:", "<Nop>", { desc = "Remove annoying exmode" })
    keymap.set("n", "c", '"_c')
    keymap.set("n", "C", '"_C')
    keymap.set("n", "s", '"_s')
    keymap.set("n", "S", '"_S')
    keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
    keymap.set("n", "<C-Down>", ":resize +2<CR>")
    keymap.set("n", "<C-Up>", ":resize -2<CR>")
    keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
    keymap.set("n", "M", function()
        vim.api.nvim_feedkeys("'", "n", {})
    end)
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

function M.do_close()
    local tabpages = vim.api.nvim_list_tabpages()
    local buffers = utils.get_valid_buffers()
    local named_buffers = vim.tbl_filter(utils.has_name, buffers)
    if #tabpages > 1 and #named_buffers <= 1 then
        vim.cmd [[:tabclose]]
    elseif #named_buffers <= 1 then
        vim.cmd [[:q]]
    elseif not vim.api.nvim_buf_get_option(0, "modifiable") then
        vim.cmd [[:bd]]
    else
        vim.cmd [[:bp | sp | bn | bd]]
    end
end

M.setup()
