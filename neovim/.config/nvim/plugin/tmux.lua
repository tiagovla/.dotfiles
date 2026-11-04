vim.pack.add({ "https://github.com/aserowy/tmux.nvim" }, { confirm = false })

local layout = require "tmux.layout.parse"
local parse_legacy_layout = layout.parse

layout.parse = function(display)
    if not display or display:sub(1, 1) ~= "{" then
        return parse_legacy_layout(display)
    end

    local ok, window = pcall(vim.json.decode, display)
    if not ok or type(window) ~= "table" or type(window.L) ~= "table" then
        return nil
    end

    local panes = {}
    local function collect(node)
        if node.t == "p" then
            table.insert(panes, {
                id = tonumber(node.I:match "^%%(%d+)$"),
                x = node.x,
                y = node.y,
                width = node.w,
                height = node.h,
            })
        else
            for _, child in ipairs(node.c or {}) do
                collect(child)
            end
        end
    end

    collect(window.L)
    return { width = window.L.w, height = window.L.h, panes = panes }
end

require("tmux").setup {
    copy_sync = {
        enable = false,
    },
    navigation = {
        enable_default_keybindings = true,
    },
    resize = {
        enable_default_keybindings = true,
    },
}
