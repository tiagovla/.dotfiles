return {
    config = function()
        require("telescope").load_extension "zoxide"
        local builtin = require "telescope.builtin"
        require("telescope._extensions.zoxide.config").setup {
            mappings = {
                ["<CR>"] = {
                    keepinsert = true,
                    action = function(selection)
                        builtin.find_files { cwd = selection.path }
                    end,
                    after_action = function(selection)
                        vim.cmd("cd " .. selection.path)
                    end,
                },
            },
        }
    end,
}
