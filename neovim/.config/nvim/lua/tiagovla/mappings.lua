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
