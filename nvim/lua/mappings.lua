local M = {}

function M.setup() M.movements() end

function M.movements()
    local movements_mappings = {
        {'n', '<C-J>', '<C-W><C-J>'}, {'n', '<C-K>', '<C-W><C-K>'}, {'n', '<C-L>', '<C-W><C-L>'},
        {'n', '<c-H>', '<C-W><C-H>'}, {'n', '<c-N>', ':bnext<cr>', {'noremap', 'silent'}},
        {'n', '<c-P>', ':bprev<cr>', {'noremap', 'silent'}}
    }
    require'ezmap'.map(movements_mappings)
end

return M

