require('lualine').setup {
    options = {
        theme = require 'plug-config.lualine.tokyo_night',
        section_separators = {'', ''},
        component_separators = {'', ''},
        -- component_separators = {'', ''},
        icons_enabled = true
    },
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}},
        lualine_c = {{'filename', file_status = true}},
        -- lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_x = {},
        -- lualine_y = {'progress'},
        lualine_y = {
            {
                'diff',
                colored = true,
                color_added = '#9ECE6A',
                color_modified = '#7AA2F7',
                color_removed = '#F7768E',
                symbols = {added = '+', modified = '~', removed = '-'}
            }, 'location'
        },
        lualine_z = {}
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
