local telescope_mappings = {
    {"n", "<C-F>", "<nop>"}, {"n", "<C-F>f", ":Telescope find_files<cr>"},
    {"n", "<C-F><C-F>", ":Telescope find_files<cr>"},
    {"n", "<C-F>g", ":Telescope live_grep<cr>"},
    {"n", "<C-F><C-G>", ":Telescope live_grep<cr>"},
    {"n", "<C-F>b", ":Telescope buffers<cr>"},
    {"n", "<C-F><C-B>", ":Telescope buffers<cr>"},
    {"n", "<C-F>h", ":Telescope help_tags<cr>"},
    {"n", "<C-F><C-H>", ":Telescope help_tags<cr>"},
    {"n", "<C-F>p", ":Telescope projects<cr>"},
    {"n", "<C-F><C-P>", ":Telescope projects<cr>"},
    {"n", "<C-F>c", ":Telescope colorscheme<cr>"},
    {"n", "<C-F><C-c>", ":Telescope colorscheme<cr>"}
}
require"ezmap".map(telescope_mappings, {"noremap", "silent"})
