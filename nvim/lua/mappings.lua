local ezmap = require("ezmap")

local M = {}

function M.setup()
    M.general()
    M.movements()
    M.plugins()
end

function M.movements()
    local movements_mappings = {
        {'n', '<C-J>', '<C-W><C-J>'}, {'n', '<C-K>', '<C-W><C-K>'}, {'n', '<C-L>', '<C-W><C-L>'},
        {'n', '<c-H>', '<C-W><C-H>'}, {'n', '<c-N>', ':bnext<cr>', {'noremap', 'silent'}},
        {'n', '<c-P>', ':bprev<cr>', {'noremap', 'silent'}}
    }
    ezmap.map(movements_mappings)
end

function M.general() ezmap.map({{'n', "<F1>", ''}}) end

function M.plugins()
    require("plug-config.whichkey.mappings")
    require("plug-config.nvimtree.mappings")
    require("plug-config.telescope.mappings")
    require("plug-config.lspsaga.mappings")
end

return M

