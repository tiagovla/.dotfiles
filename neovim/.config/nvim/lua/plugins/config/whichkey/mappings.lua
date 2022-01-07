local wk = require "which-key"

wk.register({
    d = { name = "DAP Debugger" },
    g = { name = "General", d = "Generate Docstrings" },
    h = { name = "Git Signs" },
    l = { name = "Latex", b = { "Build Document" }, v = { "Forward View" } },
    p = { name = "NvimTree" },
    q = { name = "Trouble" },
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
