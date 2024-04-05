local function toggle_win_zoom()
    local layout = {}

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        layout[win] = vim.api.nvim_win_get_config(win)
    end

    local ok, value = pcall(vim.api.nvim_win_get_var, 0, "zoomed_win")

    if ok and type(value) == "table" then
        for win, config in pairs(value) do
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_config(win, config)
            end
        end
        vim.api.nvim_win_set_var(0, "zoomed_win", nil)
    else
        local old_config = vim.api.nvim_win_get_config(0)
        local config = vim.deepcopy(old_config)
        config.width = vim.api.nvim_get_option "columns"
        config.height = vim.api.nvim_get_option "lines"
        if old_config.height ~= config.height or old_config.width ~= config.width then
            vim.api.nvim_win_set_var(0, "zoomed_win", layout)
            vim.api.nvim_win_set_config(0, config)
        end
    end
end

vim.keymap.set("n", "<leader>z", toggle_win_zoom, { desc = "Zoom in window", noremap = true, silent = true })
