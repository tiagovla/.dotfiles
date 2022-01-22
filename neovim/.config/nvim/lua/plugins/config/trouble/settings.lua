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
