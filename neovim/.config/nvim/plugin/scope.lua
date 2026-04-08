vim.pack.add { "https://github.com/tiagovla/scope.nvim", "https://github.com/tiagovla/buffercd.nvim" }
require("scope").setup { restore_state = true }
vim.keymap.set({ "n", "o", "x" }, "<c-w>T", function()
    local old_tab = vim.api.nvim_get_current_tabpage()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd [[execute "normal! \<C-W>T"]]
    local new_tab = vim.api.nvim_get_current_tabpage()
    if old_tab ~= new_tab then
        local cache = require("scope.core").cache
        cache[old_tab] = vim.tbl_filter(function(e)
            return e ~= buf
        end, cache[old_tab])
    end
end, { desc = "move into new tab", remap = true })

require("buffercd").setup {}
