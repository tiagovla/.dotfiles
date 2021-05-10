local telescope_mappings = {
    {"n", "<C-F>", "<nop>"}, {"n", "<C-F>J", ":Telescope find_files<cr>"},
    {"n", "<C-F>g", ":Telescope live_grep<cr>"}, {"n", "<C-F>b", ":Telescope buffers<cr>"},
    {"n", "<C-F>h", ":Telescope help_tags<cr>"}, {"n", "<C-F><C-F>", ":Telescope find_files<cr>"},
    {"n", "<C-F><C-G>", ":Telescope live_grep<cr>"}, {"n", "<C-F><C-B>", ":Telescope buffers<cr>"},
    {"n", "<C-F><C-H>", ":Telescope help_tags<cr>"},
}
require"ezmap".map(telescope_mappings, {"noremap", "silent"})
