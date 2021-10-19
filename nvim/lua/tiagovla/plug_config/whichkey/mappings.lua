local wk = require "which-key"

wk.register({
    t = {
        name = "Telescope",
        c = { "Colorscheme" },
        f = { "Files" },
        g = { "Grep" },
        h = { "Tags" },
        o = { "Old files" },
        p = { "Projects" },
    },
}, {
    prefix = "<Space>",
})
