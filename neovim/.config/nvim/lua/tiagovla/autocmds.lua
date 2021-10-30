local M = {}
local history = {}

vim.api.nvim_exec(
    [[
      augroup TrackCWD
        autocmd!
        autocmd BufEnter * lua require"tiagovla.autocmds".on_enter()
        autocmd BufLeave * lua require"tiagovla.autocmds".on_leave()
      augroup end
    ]],
    false
)

function M.on_enter()
    local buf = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_get_option(buf, "buflisted") then
        return
    end

    local past_path = history[buf]
    if past_path then
        vim.fn.execute("cd " .. past_path, "silent")
        require("nvim-tree").change_dir(past_path) --update nvimtree
    end
end

function M.on_leave()
    local buf = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_get_option(buf, "buflisted") then
        return
    end

    local path = vim.fn.getcwd(-1, -1)
    history[buf] = path
end

return M
