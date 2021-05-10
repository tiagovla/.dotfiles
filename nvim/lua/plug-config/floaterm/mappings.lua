vim.g.floaterm_keymap_toggle = "<F1>"
vim.g.floaterm_keymap_next = "<F2>"
vim.g.floaterm_keymap_prev = "<F3>"
vim.g.floaterm_keymap_new = "<F4>"

local telescope_mappings = {
    {"n", "<F1>", ":FloatermToggle<cr>"}, {"n", "<F2>", ":FloatermNext<cr>"},
    {"n", "<F3>", ":FloatermPrev<cr>"}, {"n", "<F4>", ":FloatermNew<cr>"},
}
require"ezmap".map(telescope_mappings, {"noremap", "silent"})
