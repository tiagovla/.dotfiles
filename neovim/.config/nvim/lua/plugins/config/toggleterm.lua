local keymap = vim.keymap

local function mappings()
    keymap.set({ "n", "v", "t" }, "<F1>", "<nop>")
    keymap.set({ "n", "v" }, "<F1>", "<cmd>:ToggleTerm <cr>")
    keymap.set({ "n", "v" }, "<C-_>", "<cmd>:ToggleTerm size=12 direction=horizontal <cr>")

    local function set_terminal_keymaps()
        keymap.set("t", "<F1>", "<cmd>:ToggleTerm <cr>")
        keymap.set("t", "<F2>", "<cmd>:ToggleTerm <cr>")
        keymap.set("t", "<C-_>", "<cmd>:ToggleTerm <cr>")
        keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]])
        keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]])
        keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]])
        keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]])
    end

    vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", callback = set_terminal_keymaps })
end

local function config()
    require("toggleterm").setup {
        size = 20,
        hide_numbers = true,
        start_in_insert = true,
        insert_mappings = true,
        shade_terminals = true,
        shading_factor = 2,
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
    cmd = { "ToggleExec", "ToggleTerm" },
    config = config,
}
