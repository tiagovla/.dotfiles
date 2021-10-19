local telescope_mappings = {
    { "n", "<C-F>", "<nop>" },
    { "n", "<C-F><C-F>", ":Telescope find_files<cr>" },
    { "n", "<C-F><C-G>", ":Telescope live_grep<cr>" },
    { "n", "<C-F><C-B>", ":Telescope buffers<cr>" },
    { "n", "<C-F><C-O>", ":Telescope oldfiles<cr>" },
    { "n", "<C-F><C-H>", ":Telescope help_tags<cr>" },
    { "n", "<C-F><C-c>", ":Telescope colorscheme<cr>" },
    { "n", "<C-F><C-P>", ":Telescope project<cr>" },
    { "n", "<C-F><C-s>", ":SearchSession<cr>" },

    { "n", "<space>tf", ":Telescope find_files<cr>" },
    { "n", "<space>tg", ":Telescope live_grep<cr>" },
    { "n", "<space>tb", ":Telescope buffers<cr>" },
    { "n", "<space>th", ":Telescope help_tags<cr>" },
    { "n", "<space>tc", ":Telescope colorscheme<cr>" },
    { "n", "<space>tp", ":Telescope project<cr>" },
}
require("ezmap").map(telescope_mappings, { "noremap", "silent" })
