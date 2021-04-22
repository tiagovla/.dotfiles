local telescope_mappings = {
    {'n', '<C-F>', "<nop>"},
    {'n', '<C-F>J', ":lua require('telescope.builtin').find_files()<cr>"},
    {'n', '<C-F>g', ":lua require('telescope.builtin').live_grep()<cr>"},
    {'n', '<C-F>b', ":lua require('telescope.builtin').buffers()<cr>"},
    {'n', '<C-F>h', ":lua require('telescope.builtin').help_tags()<cr>"},
    {'n', '<C-F><C-F>', ":lua require('telescope.builtin').find_files()<cr>"},
    {'n', '<C-F><C-G>', ":lua require('telescope.builtin').live_grep()<cr>"},
    {'n', '<C-F><C-B>', ":lua require('telescope.builtin').buffers()<cr>"},
    {'n', '<C-F><C-H>', ":lua require('telescope.builtin').help_tags()<cr>"}
}
require'ezmap'.map(telescope_mappings, {'noremap', 'silent'})
