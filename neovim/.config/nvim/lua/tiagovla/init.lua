require "tiagovla.settings"
require "tiagovla.globals"

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require "tiagovla.mappings"
        require "tiagovla.autocmds"
        require "tiagovla.commands"
    end,
})
