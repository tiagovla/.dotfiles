local M = {}

local function get_lua_path()
    -- Path to this source file, removing the leading '@'
    local source = string.sub(debug.getinfo(1, "S").source, 2)

    -- Path to the package root
    return vim.fn.fnamemodify(source, ":p:h")
end

function M.get_path_sep()
    return vim.fn.has "win32" == 1 and "\\" or "/"
end

-- Returns a function that joins the given arguments with separator. Arguments
-- can't be nil. Example:
--[[
print(M.generate_join(" ")("foo", "bar"))
--]]
-- prints "foo bar"
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
