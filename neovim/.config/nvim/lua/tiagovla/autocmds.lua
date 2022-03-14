local M = {}

local function on_dir_change()
    local path = vim.fn.getcwd(-1, -1)
    require("nvim-tree").change_dir(path)
end
vim.api.nvim_create_autocmd("DirChanged", { callback = on_dir_change })

return M
