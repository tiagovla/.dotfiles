-- Copyright (c) 2021-2021 tiagovla
-- License: MIT
-- Credit: https://github.com/enkia/tokyo-night-vscode-theme
--
local colors = {
    bg = "#11121D",
    fg = "#45486A",
    red = "#EE6D85",
    green = "#95C561",
    yellow = "#D7A65F",
    blue = "#7199EE",
    purple = "#9175C3",
    cyan = "#41B1A6",
    gray = "#A3A7C7"
}

local tokyo_night = {
    inactive = {
        a = {fg = colors.gray, bg = colors.bg, gui = 'bold'},
        b = {fg = colors.gray, bg = colors.bg},
        c = {fg = colors.bg, bg = colors.bg},
        z = {fg = colors.gray, bg = colors.bg}
    },
    normal = {
        a = {fg = colors.bg, bg = colors.green, gui = 'bold'},
        b = {fg = colors.gray, bg = colors.bg},
        c = {fg = colors.gray, bg = colors.bg},
        z = {fg = colors.gray, bg = colors.bg}
    },
    visual = {a = {fg = colors.bg, bg = colors.purple, gui = 'bold'}},
    replace = {a = {fg = colors.bg, bg = colors.red, gui = 'bold'}},
    insert = {a = {fg = colors.bg, bg = colors.blue, gui = 'bold'}}
}

return tokyo_night
