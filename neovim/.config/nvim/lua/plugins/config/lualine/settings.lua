local theme = require "lualine.themes.tokyodark"
local p = require "tokyodark.palette"

local colors = {
    diff_add = "#9ECE6A",
    diff_modify = "#7AA2F7",
    diff_remove = "#F7768E",
    border = p.bg5,
}

for _, session in pairs(theme.inactive) do
    session.gui = "underline"
    session.fg = colors.border
end

require("lualine").setup {
    options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        icons_enabled = true,
    },
    sections = {
        lualine_a = { { "mode", upper = true } },
        lualine_b = { { "branch", icon = "" } },
        lualine_c = {},
        lualine_x = { "filetype" },
        lualine_y = {
            {
                "diff",
                colored = true,
                diff_color = {
                    added = { fg = colors.diff_add },
                    modified = { fg = colors.diff_modify },
                    removed = { fg = colors.diff_remove },
                },
                symbols = { added = "+", modified = "~", removed = "-" },
            },
            "location",
        },
        lualine_z = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { { sections = { lualine_b = { "filetype" } }, filetypes = { "NvimTree" } } },
}
