require('lualine').setup {
    options = {
        theme = require 'plug-config.lualine.tokyo_night',
        section_separators = {'', ''},
        component_separators = {'', ''},
        icons_enabled = true
    },
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}},
        lualine_c = {{'filename', file_status = true}},
        -- lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_x = {},
        -- lualine_y = {'progress'},
        lualine_y = {},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {'fugitive'}
}
