require("toggleterm").setup {
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    open_mapping = [[<F1>]],
    shade_terminals = true,
    shading_factor = "0",
    persist_size = true,
    close_on_exit = false,
    direction = "float",
    float_opts = {
        border = "curved",
        winblend = 0,
        highlights = { border = "Normal", background = "Normal" },
    },
}
