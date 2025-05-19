local ts_utils = require "nvim-treesitter.ts_utils"

local run_formatter = function(text)
    local result = table.concat(text, " ")
    -- vim.print(result)
    local width = vim.opt.textwidth:get() or "80"
    local j = require("plenary.job"):new {
        command = "fmt",
        args = { "-w" .. width, "-u" },
        writer = { result },
    }
    return j:sync()
end

-- Get the start and end positions of the given nodes.
local function get_min_max_range(nodes)
    local min, max = nodes[1]:start(), nodes[1]:end_()
    for _, node in ipairs(nodes) do
        local start = node:start()
        local end_ = node:end_()
        min = math.min(min, start)
        max = math.max(max, end_)
    end
    return min, max
end

-- Get the root node of the tree for a specific filetype.
local function get_root_node(bufnr, ft)
    local parser = vim.treesitter.get_parser(bufnr, ft)
    local tree = parser:parse()[1]
    return tree:root()
end

-- Format the lines from `start_line` to `end_line`.
local function format_lines(start_line, end_line)
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd "normal! V" -- Enter visual mode
    vim.api.nvim_win_set_cursor(0, { end_line, 0 }) -- Select lines up to `end_line`
    vim.cmd "normal! gq" -- Apply formatting
end

-- Group nodes of specific types ("text" and "inline_formula") and format them.
local function group_and_format_nodes()
    local groups = {}
    local current_group = {}
    local types_to_group = { "text", "inline_formula", ",", ")" }
    local root = get_root_node(0, "latex")

    -- Iterate over the root's children and group the nodes
    for child in root:iter_children() do
        if child:type() == "generic_environment" then
            for grandchild in child:iter_children() do
                if vim.tbl_contains(types_to_group, grandchild:type()) then
                    table.insert(current_group, grandchild)
                elseif #current_group > 0 then
                    table.insert(groups, current_group)
                    current_group = {} -- Start a new group
                end

                if grandchild:type() == "section" then
                    for grandgrandchild in grandchild:iter_children() do
                        -- vim.print(grandgrandchild:type())
                        if vim.tbl_contains(types_to_group, grandgrandchild:type()) then
                            table.insert(current_group, grandgrandchild)
                        elseif #current_group > 0 then
                            table.insert(groups, current_group)
                            current_group = {} -- Start a new group
                        end

                        if grandgrandchild:type() == "subsection" then
                            for grandgrandgrandchild in grandgrandchild:iter_children() do
                                -- vim.print(grandgrandgrandchild:type())
                                if vim.tbl_contains(types_to_group, grandgrandgrandchild:type()) then
                                    table.insert(current_group, grandgrandgrandchild)
                                elseif #current_group > 0 then
                                    table.insert(groups, current_group)
                                    current_group = {} -- Start a new group
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    -- Insert last group if not empty
    if #current_group > 0 then
        table.insert(groups, current_group)
    end

    -- Save current cursor position and format the groups in reverse order
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    for i = #groups, 1, -1 do
        local group = groups[i]
        local min, max = get_min_max_range(group)
        -- vim.print { min, max }
        format_lines(min + 1, max + 1) -- +1 because Lua is 1-indexed
    end
    -- Restore the cursor position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
end

-- Keymap for formatting the block
vim.keymap.set("n", "<space><space>q", group_and_format_nodes, {})
