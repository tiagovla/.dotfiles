local M = {
    "akinsho/toggleterm.nvim",
    lazy = false,
}

local function slice_from_match(list, match)
    local function find_index(tbl, element)
        for i, v in ipairs(tbl) do
            if v == element then
                return i
            end
        end
        return nil
    end
    local index = find_index(list, match)
    if index then
        return { unpack(list, index + 1) }
    else
        return list
    end
end

function M.init()
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
    end
    vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", callback = set_terminal_keymaps })
end

function M.config()
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

    local lines = {}
    local running_cmd = false

    local on_data = function(_, _, data)
        for i, line in ipairs(data) do
            data[i] = line:gsub("\r", ""):gsub("\27%[[0-9;]*m", "")
        end
        for _, v in pairs(data) do
            if v == "async_make_done" then
                running_cmd = false
                local output = slice_from_match(lines, "async_make_start")
                output = vim.tbl_filter(function(line)
                    return line ~= ""
                end, output)

                local efm = vim.api.nvim_get_option_value("errorformat", { buf = 0 })
                vim.fn.setqflist({}, " ", {
                    title = "make",
                    lines = output,
                    efm = efm,
                })
                vim.api.nvim_command "doautocmd QuickFixCmdPost"
                vim.notify "Make command ended"
            end
        end

        if running_cmd then
            vim.list_extend(lines, data)
        end
    end

    local on_exit = function()
        running_cmd = false
        lines = {}
    end

    local term_float = Terminal:new {
        hidden = true,
        direction = "float",
        on_stdout = on_data,
        on_stderr = on_data,
        on_exit = on_exit,
    }

    local function make()
        require "toggleterm.terminal"
        if not term_float:is_open() then
            term_float:toggle()
            term_float:toggle()
        end
        lines = {}
        term_float:send({ "echo async_make_start; make; echo async_make_done" }, false)
        running_cmd = true
        vim.notify "Make command running..."
    end

    vim.api.nvim_create_user_command("Make", make, {})
    vim.keymap.set({ "n", "i", "x", "t" }, "<F2>", "<cmd>Make<cr>")
    vim.keymap.set({ "n", "i", "x" }, "<c-?>", "<cmd>Make<cr>")

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

return M
