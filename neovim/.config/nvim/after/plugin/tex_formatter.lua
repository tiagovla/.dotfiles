local run_formatter = function(text)
    local result = table.concat(text, " ")
    vim.pretty_print(result)
    local width = vim.opt.textwidth:get() or "80"

    local j = require("plenary.job"):new {
        command = "fmt",
        args = { "-w" .. width, "-u" },
        writer = { result },
    }
    return j:sync()
end
local function format_block()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    local text_node
    local type_list = { "text", "inline_formula" }
    while node do
        if vim.tbl_contains(type_list, node:type()) then
            text_node = node
        end
        node = node:parent()
    end
    if not text_node then
        return
    end
    local prev = text_node
    while prev:prev_named_sibling() do
        if not vim.tbl_contains(type_list, prev:prev_named_sibling():type()) then
            break
        end
        prev = prev:prev_named_sibling()
    end
    local next = text_node
    while next:next_named_sibling() do
        if not vim.tbl_contains(type_list, next:next_named_sibling():type()) then
            break
        end
        next = next:next_named_sibling()
    end
    local start, _ = prev:start()
    local end_, _ = next:end_()
    local res = vim.api.nvim_buf_get_lines(0, start, end_ + 1, false)
    local r = run_formatter(res)
    vim.api.nvim_buf_set_lines(0, start, end_ + 1, false, r)
end

vim.keymap.set("n", "gqq", format_block, {})
