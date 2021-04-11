-- Copyright (c) 2021-2021 tiagovla
-- License: MIT
-- Credit: https://github.com/enkia/tokyo-night-vscode-theme
--
local colors = {
    -- ! black
    bg = "#1a1b26",
    fg = "#4e5173",
    red = "#F7768E",
    green = "#9ECE6A",
    yellow = "#E0AF68",
    blue = "#7AA2F7",
    purple = "#9a7ecc",
    cyan = "#4abaaf",
    gray = "#acb0d0"
}

local tokyo_night = {
    inactive = {
        a = {fg = colors.gray, bg = colors.bg, gui = 'bold'},
        b = {fg = colors.gray, bg = colors.bg},
        c = {fg = colors.bg, bg = colors.bg}
    },
    normal = {
        a = {fg = colors.bg, bg = colors.green, gui = 'bold'},
        b = {fg = colors.gray, bg = colors.bg},
        c = {fg = colors.gray, bg = colors.bg}
    },
    visual = {a = {fg = colors.bg, bg = colors.purple, gui = 'bold'}},
    replace = {a = {fg = colors.bg, bg = colors.red, gui = 'bold'}},
    insert = {a = {fg = colors.bg, bg = colors.blue, gui = 'bold'}}
}

return tokyo_night
