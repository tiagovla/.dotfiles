require("toggleterm").setup {
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    shade_terminals = true,
    shading_factor = "1",
    persist_size = true,
    close_on_exit = true,
    direction = "float",
    float_opts = {
        border = "curved",
        winblend = 0,
        highlights = { border = "Normal", background = "Normal" },
    },
}
