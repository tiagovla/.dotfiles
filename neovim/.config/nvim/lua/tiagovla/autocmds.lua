local history = {}
local last_exit = 1
local M = {}

local function check_valid_buf(buf)
    return vim.api.nvim_buf_get_option(buf, "buflisted") and buf ~= last_exit
end

local function on_enter()
    local buf = vim.api.nvim_get_current_buf()
    if not check_valid_buf(buf) then
        return
    end

    local past_path = history[buf]
    if past_path then
        vim.fn.execute("cd " .. past_path)
        require("nvim-tree").change_dir(past_path) --update nvimtree
    end
end

local function on_leave()
    local buf = vim.api.nvim_get_current_buf()
    if not check_valid_buf(buf) then
        return
    end
    last_exit = buf
    history[buf] = vim.fn.getcwd(-1, -1)
end

local function print_summary()
    for k, v in pairs(history) do
        local name = vim.api.nvim_buf_get_name(k)
        print(name .. " " .. v)
    end
end

vim.api.nvim_create_augroup("TrackCWD", {})
vim.api.nvim_create_autocmd("BufEnter", { group = "TrackCWD", callback = on_enter })
vim.api.nvim_create_autocmd("BufLeave", { group = "TrackCWD", callback = on_leave })
vim.api.nvim_add_user_command("PWDList", print_summary, {})

return M
