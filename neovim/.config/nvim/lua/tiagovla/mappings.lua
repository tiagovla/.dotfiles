local utils = require "tiagovla.utils"

local M = {}

function M.setup()
    M.general()
    M.movements()
end

function M.general()
    vim.keymap.set("n", "n", "nzzzv")
    vim.keymap.set("n", "N", "Nzzzv")
    vim.keymap.set("n", "G", "Gzzzv")
    vim.keymap.set("n", "J", "mzJ`z")
    vim.keymap.set("i", ",", ",<c-g>u")
    vim.keymap.set("i", ".", ".<c-g>u")
    vim.keymap.set("i", "!", "!<c-g>u")
    vim.keymap.set("i", "?", "?<c-g>u")
    vim.keymap.set("v", "J", ":m .+1<cr>gv=gv", { silent = true })
    vim.keymap.set("v", "K", ":m .-2<cr>gv=gv", { silent = true })
    vim.keymap.set("n", "<leader>s", ":vsplit<cr>", { silent = true, desc = "Vertical split" })
    vim.keymap.set("n", "<leader>q", M.better_close, { desc = "Close buffer" })
    vim.keymap.set("n", "<leader>Q", ":%bd|e#<cr>", { desc = "Close all other buffers" })
    vim.cmd [[nnoremap <C-i> <C-i>]]
    vim.keymap.set("n", "<Tab>", ":b#<cr>", { silent = true, desc = "Switch buffers" })
    vim.keymap.set("n", "[q", ":cnext<cr>", { silent = true, desc = "Next item in quickfix list" })
    vim.keymap.set("n", "]q", ":cprev<cr>", { silent = true, desc = "Previous item in quickfix list" })
    vim.keymap.set("n", "<CR>", [[{-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()]], { silent = true, expr = true })
    vim.keymap.set(
        { "n", "x", "o" },
        "n",
        '"Nn"[v:searchforward]',
        { expr = true, desc = "Better forward N behaviour" }
    )
    vim.keymap.set(
        { "n", "x", "o" },
        "N",
        '"nN"[v:searchforward]',
        { expr = true, desc = "Better backward N behaviour" }
    )
    vim.keymap.set("v", "<", "<gv", { desc = "Dedent current selection" })
    vim.keymap.set("v", ">", ">gv", { desc = "Indent current selection" })
    vim.keymap.set("n", "/", "ms/", { desc = "Keeps jumplist after forward searching" })
    vim.keymap.set("n", "?", "ms?", { desc = "Keeps jumplist after backward searching" })
    vim.keymap.set("n", "Q", "<Nop>", { desc = "Remove annoying exmode" })
    vim.keymap.set("n", "q:", "<Nop>", { desc = "Remove annoying exmode" })
    vim.keymap.set("n", "c", '"_c')
    vim.keymap.set("n", "C", '"_C')
    vim.keymap.set("n", "s", '"_s')
    vim.keymap.set("n", "S", '"_S')
    vim.keymap.set("n", "c_", '"_c^')
    vim.keymap.set("n", "d_", '"_d^')
    vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
    vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
    vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
    vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
    vim.keymap.set("v", "p", "P")
    vim.keymap.set("n", "gx", function()
        vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>", nil, nil) }, { detach = true })
    end, {})
    vim.keymap.set("n", "<leader>w", [[<esc><cmd>call feedkeys("\<lt>c-w>")<cr>]], { silent = true })
    vim.keymap.set("n", "<leader><leader>s", ":luafile %<cr>")
end

function M.movements()
    vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
    vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
    vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
    vim.keymap.set("n", "<c-H>", "<C-W><C-H>")
    vim.keymap.set({ "i", "v" }, "<C-J>", "<Esc><C-W><C-J>")
    vim.keymap.set({ "i", "v" }, "<C-K>", "<Esc><C-W><C-K>")
    vim.keymap.set({ "i", "v" }, "<C-L>", "<Esc><C-W><C-L>")
    vim.keymap.set({ "i", "v" }, "<c-H>", "<Esc><C-W><C-H>")
    vim.keymap.set("n", "<c-N>", "<cmd>BufferLineCycleNext<cr>")
    vim.keymap.set("n", "<c-P>", "<cmd>BufferLineCyclePrev<cr>")
    vim.keymap.set("n", "H", "gT")
    vim.keymap.set("n", "L", "gt")
    vim.keymap.set({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    vim.keymap.set("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    vim.keymap.set("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    vim.keymap.set("n", "#", M.better_hlsearch)
    vim.keymap.set("n", "*", M.better_hlsearch)
end

function M.better_hlsearch()
    local current_word = vim.call("expand", "<cword>")
    vim.fn.setreg("/", "\\<" .. current_word .. "\\>")
    vim.api.nvim_command "set hlsearch"
end

function M.better_close()
    local tabpages = vim.api.nvim_list_tabpages()
    local buffers = utils.get_valid_buffers()
    local named_buffers = vim.tbl_filter(utils.buf_has_name, buffers)
    if not vim.bo[0].buflisted then
        vim.api.nvim_win_close(0, false)
        return
    end
    if #tabpages > 1 and #named_buffers <= 1 then
        vim.cmd.Bdelete()
    elseif #buffers <= 1 and not utils.buf_has_name(0) then
        vim.cmd.quit()
    else
        vim.cmd.Bdelete()
    end
end

M.setup()
