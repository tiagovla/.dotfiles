local ezmap = require('ezmap')

function _G.nvim_tree_smart_toggle()
    local buftype = vim.api.nvim_buf_get_option(0, 'filetype')
    if buftype ~= "NvimTree" then
        vim.cmd("NvimTreeFindFile")
    else
        vim.cmd("NvimTreeToggle")
    end
end


local nvimtree_mappings = {
    {'n', '<c-P>', ':lua nvim_tree_smart_toggle()<CR>'},
    {'n', '<space>p', ':lua nvim_tree_smart_toggle()<CR>'}
}

ezmap.map(nvimtree_mappings, {'noremap', 'silent'})
