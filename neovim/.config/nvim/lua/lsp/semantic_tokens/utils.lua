local M = {}

local function get_lua_path()
    local source = string.sub(debug.getinfo(1, "S").source, 2)
    return vim.fn.fnamemodify(source, ":p:h")
end

function M.get_path_sep()
    return vim.fn.has "win32" == 1 and "\\" or "/"
end

function M.generate_join(separator)
    return function(...)
        return table.concat({ ... }, separator)
    end
end

M.join_path = M.generate_join(M.get_path_sep())

function M.get_preset_file(preset)
    return M.join_path(get_lua_path(), preset .. ".lua")
end

return M
