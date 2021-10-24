local ok, _ = pcall(require, "nvim-tree")
if ok then
    vim.cmd "autocmd User NeogitStatusRefreshed lua require('nvim-tree').refresh()"
end
