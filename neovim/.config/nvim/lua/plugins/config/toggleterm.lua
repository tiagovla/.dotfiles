local keymap = vim.keymap

local function mappings()
    keymap.set("n", "<F1>", "<cmd>ToggleTerm<cr>")

    function _G.set_terminal_keymaps()
        keymap.set("t", [[<F1>]], "<cmd>:ToggleTerm <cr>")
        keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]])
        keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]])
        keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]])
        keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]])
    end

    vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
end

local function config()
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
end

mappings()
return {
    config = config,
}
