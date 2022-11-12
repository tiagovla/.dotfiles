local function setup()
    vim.keymap.set({ "n", "i", "v", "t", "x" }, "<F1>", "<nop>")
    vim.keymap.set({ "n", "v" }, "<F1>", "<cmd>TermFloat<cr>")
    vim.keymap.set({ "n", "v" }, "<C-_>", "<cmd>TermBottom<cr>")
    vim.keymap.set({ "n", "v" }, "<leader>G", "<cmd>Lazygit<cr>")

    local function set_terminal_keymaps()
        vim.keymap.set("t", "<F1>", "<cmd>TermFloat<cr>")
        vim.keymap.set("t", "<C-_>", "<cmd>TermBottom<cr>")
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]])
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]])
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]])
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]])
        vim.keymap.set("t", "H", "<cmd>tabprev<cr>")
        vim.keymap.set("t", "L", "<cmd>tabnext<cr>")
    end

    vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", callback = set_terminal_keymaps })
end

local function config()
    require("toggleterm").setup {
        size = 20,
        hide_numbers = true,
        autochdir = true,
        start_in_insert = true,
        insert_mappings = true,
        shade_terminals = true,
        shading_factor = 2,
        persist_size = true,
        close_on_exit = true,
        direction = "float",
        highlights = { FloatBorder = { guifg = "#4A5057" } },
        float_opts = {
            border = "curved",
            winblend = 0,
        },
    }

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new { cmd = "lazygit", hidden = true, direction = "tab" }
    local term_float = Terminal:new { hidden = true, direction = "float" }
    local function _smart_toggle(terminal, size, direction)
        if terminal:is_open() and terminal.direction ~= direction then
            terminal:toggle(size, direction)
            terminal:toggle(size, direction)
        elseif terminal:is_open() and not terminal:is_focused() then
            terminal:focus()
            terminal:set_mode "i"
        else
            terminal:toggle(size, direction)
        end
    end
    local function setup_cmd(cmd, term, size, direction)
        vim.api.nvim_create_user_command(cmd, function()
            _smart_toggle(term, size, direction)
        end, {})
    end
    setup_cmd("Lazygit", lazygit, nil, "tab")
    setup_cmd("TermFloat", term_float, 20, "float")
    setup_cmd("TermBottom", term_float, 12, "horizontal")
    setup_cmd("TermRight", term_float, 50, "vertical")
end

return {
    setup = setup,
    cmd = { "ToggleExec", "ToggleTerm", "Lazygit", "TermFloat", "TermBottom", "TermRight" },
    config = config,
}
