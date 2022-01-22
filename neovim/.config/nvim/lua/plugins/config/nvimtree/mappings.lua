local keymap = vim.keymap

local function nvim_tree_smart_toggle()
    local buftype = vim.api.nvim_buf_get_option(0, "filetype")
    vim.cmd "NvimTreeRefresh"
    if buftype ~= "NvimTree" then
        if buftype == "" then
            vim.cmd "NvimTreeFocus"
        else
            vim.cmd "NvimTreeFindFile"
        end
    else
        vim.cmd "NvimTreeToggle"
    end
end

keymap.set("n", "<leader>p", nvim_tree_smart_toggle)
