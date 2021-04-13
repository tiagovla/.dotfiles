local map = require('utils.functions')["map"]
local g = vim.g

g.which_key_timeout = 100
g.which_key_display_names = {["<CR>"] = "↵", ["<TAB>"] = "⇆"}

map("n", "<space>", [[:silent <c-u> :silent WhichKey '<space>' <CR>]],
    {silent = true, noremap = true})
map("v", "<space>", [[:silent <c-u> :silent WhichKeyVisual '<space>' <CR>]],
    {silent = true, noremap = true})

g.which_key_map = {}
g.which_key_sep = '→'
g.which_key_use_floating_win = 0
g.which_key_max_size = 0

local which_key_space = {}

which_key_space["t"] = {
    ["name"] = "+terminal",
    ["g"] = {":FloatermNew lazygit", "git"},
    ["d"] = {":FloatermNew lazydocker", "docker"},
    ["t"] = {":FloatermToggle", "terminal"},
    ["p"] = {":FloaterNew python", "python"}
}

which_key_space["l"] = {
    ["name"] = "+latex",
    ["b"] = {":TexlabBuild", "build"},
    ["v"] = {":TexlabForward", "forward"}
}

which_key_space["b"] = {
    ["name"] = "+buffer",
    ["f"] = {":bfirst", "firstbuffer"},
    ["l"] = {":blast", "last buffer"},
    ["n"] = {":bnext", "next buffer"},
    ["p"] = {":bprevious", "previous buffer"},
    ["?"] = {":buffers", "buffers"}
}

which_key_space["p"] = {":NvimTreeToggle", "nvim tree"}

which_key_space["u"] = {":UndotreeToggle", "undo tree"}

g.which_key_space = which_key_space

vim.call('which_key#register', '<Space>', "g:which_key_space")
