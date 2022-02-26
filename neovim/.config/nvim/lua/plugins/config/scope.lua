local session = setmetatable({}, {
    __index = function(table, key)
        local rtn = {}
        rawset(table, key, rtn)
        return rtn
    end,
})

vim.api.nvim_exec(
    [[
      augroup ScopeAU
        autocmd!
        autocmd BufEnter * lua require("plugins.config.scope").on_buf_open()
        autocmd BufDelete * lua require("plugins.config.scope").on_buf_close()
      augroup end
    ]],
    false
)

local function get_buf_tab()
    local buf = vim.api.nvim_get_current_buf()
    local tab = vim.api.nvim_get_current_tabpage()
    if vim.api.nvim_buf_get_option(buf, "buflisted") then
        return { tab, buf }
    end
    return {}
end

local M = {}

function M.on_buf_open()
    local tab, buf = unpack(get_buf_tab())
    if tab == nil then
        return
    end
    session[tab][buf] = buf
end

function M.on_buf_close()
    local tab, buf = unpack(get_buf_tab())
    if tab == nil then
        return
    end
    session[tab][buf] = nil
end

function M.show_bufs()
    local tab = vim.api.nvim_get_current_tabpage()
    return vim.tbl_values(session[tab])
end

return M
