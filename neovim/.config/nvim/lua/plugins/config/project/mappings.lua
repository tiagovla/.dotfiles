local mappings = {
    { "n", "<C-F>p", ":Telescope project<cr>" },
    { "n", "<C-F><C-P>", ":Telescope project<cr>" },
}
require("ezmap").map(mappings, { "noremap", "silent" })
