local keymap = vim.keymap

local function mappings()
    keymap.set("n", "]t", function()
        require("trouble").next { skip_groups = true, jump = true }
    end, { desc = "Next trouble" })

    keymap.set("n", "[t", function()
        require("trouble").previous { skip_groups = true, jump = true }
    end, { desc = "Previous trouble" })

    keymap.set("n", "<space>tt", function()
        require("trouble").toggle { focus = false }
    end, { desc = "Trouble" })
end

local function config()
    require("trouble").setup {
        use_diagnostic_signs = true,
        auto_open = false,
        auto_close = true,
    }

    local actions = require "telescope.actions"
    local trouble = require "trouble.providers.telescope"

    local telescope = require "telescope"

    telescope.setup {
        defaults = {
            mappings = {
                i = { ["<c-t>"] = trouble.open_with_trouble },
                n = { ["<c-t>"] = trouble.open_with_trouble },
            },
        },
    }
end

mappings()
return {
    config = config,
}
