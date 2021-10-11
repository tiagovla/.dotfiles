local ezmap = require("ezmap")
local M = {}

function M.setup()
    M.general()
    M.movements()
    M.plugins()
end

function M.movements()
    local movements_mappings = {
        {"n", "<C-J>", "<C-W><C-J>"}, {"n", "<C-K>", "<C-W><C-K>"},
        {"n", "<C-L>", "<C-W><C-L>"}, {"n", "<c-H>", "<C-W><C-H>"},
        {"n", "<c-N>", ":bnext<cr>", {"noremap", "silent"}},
        {"n", "<c-P>", ":bprev<cr>", {"noremap", "silent"}}, {"n", "H", "gt"},
        {"n", "L", "gT"}
    }
    ezmap.map(movements_mappings)
end

function M.general() end

function M.plugins()
    local plugins_mappings = {
        {"n", "<space>gd", ":DogeGenerate <cr>"},
        {"n", "<space>gr", ":lua require'utils.lsp'.rename() <cr>"}
    }
    require("ezmap").map(plugins_mappings, {"noremap", "silent"})
end

return M
