local M = {}

M.session = setmetatable({}, {
    __index = function(table, key)
        local rtn = {}
        rawset(table, key, rtn)
        return rtn
    end,
})

local function get_buf_tab()
    local buf = vim.api.nvim_get_current_buf()
    local tab = vim.api.nvim_get_current_tabpage()
    if vim.api.nvim_buf_get_option(buf, "buflisted") then
        return { tab, buf }
    end
    return {}
end

function M.on_buf_open()
    local tab, buf = unpack(get_buf_tab())
    if tab ~= nil then
        M.session[tab][buf] = buf
    end
end

function M.on_buf_delete()
    local tab, buf = unpack(get_buf_tab())
    if tab ~= nil then
        M.session[tab][buf] = nil
    end
end

function M.on_tab_close()
    local tab_list = vim.api.nvim_list_tabpages()
    for _, tab in pairs(vim.tbl_keys(M.session)) do
        if not vim.tbl_contains(tab_list, tab) then
            M.session[tab] = nil
        end
    end
end

function M.close_all_bufs_but_this()
    local tab, buf = unpack(get_buf_tab())
    if tab ~= nil then
        M.session[tab][buf] = nil
    end
end

function M.show_bufs()
    local tab = vim.api.nvim_get_current_tabpage()
    return vim.tbl_values(M.session[tab])
end

local function print_summary()
    for tab, buf_item in pairs(M.session) do
        for buf, _ in pairs(buf_item) do
            local name = vim.api.nvim_buf_get_name(buf)
            print(tab .. " " .. buf .. " " .. name)
        end
    end
end

vim.api.nvim_create_augroup("ScopeAU", {})
vim.api.nvim_create_autocmd("BufEnter", { group = "ScopeAU", callback = M.on_buf_open })
vim.api.nvim_create_autocmd("BufDelete", { group = "ScopeAU", callback = M.on_buf_delete })
vim.api.nvim_create_autocmd("TabClosed", { group = "ScopeAU", callback = M.on_tab_close })
vim.api.nvim_add_user_command("ScopeList", print_summary, {})

return M
