local history = {}
local last_exit_buf = 0
local M = {}

local function check_valid_buf(buf_num)
    if not buf_num or buf_num < 1 then
        return false
    end
    local exists = vim.api.nvim_buf_is_valid(buf_num)
    return vim.bo[buf_num].buflisted and exists and buf_num ~= last_exit_buf
end

local function on_enter()
    local buf = vim.api.nvim_get_current_buf()
    if not check_valid_buf(buf) then
        return
    end
    local past_path = history[buf]
    if past_path then
        vim.defer_fn(function()
            vim.api.nvim_set_current_dir(past_path)
        end, 0)
    end
end

local function on_leave()
    local buf = vim.api.nvim_get_current_buf()
    if not check_valid_buf(buf) then
        return
    end
    last_exit_buf = buf
    history[buf] = vim.fn.getcwd(-1, -1)
end

local function print_summary()
    for k, v in pairs(history) do
        local name = vim.api.nvim_buf_get_name(k)
        print(name .. " " .. v)
    end
end

local function on_neogit_refresh()
    vim.cmd [[:NvimTreeRefresh]]
end

local function on_dir_change()
    local path = vim.fn.getcwd(-1, -1)
    require("nvim-tree").change_dir(path)
end
vim.api.nvim_create_augroup("TrackCWD", {})
vim.api.nvim_create_autocmd("BufEnter", { group = "TrackCWD", callback = on_enter })
vim.api.nvim_create_autocmd("BufLeave", { group = "TrackCWD", callback = on_leave })
vim.api.nvim_create_autocmd("DirChanged", { group = "TrackCWD", callback = on_dir_change })
vim.api.nvim_add_user_command("PWDList", print_summary, {})
vim.api.nvim_create_autocmd(
    "User",
    { pattern = "NeogitStatusRefreshed", group = "TrackCWD", callback = on_neogit_refresh }
)

return M
