-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
    end,
})

-- keep cursor position after yanking
local cursor_position
vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
    group = vim.api.nvim_create_augroup("RestoreCursor", {}),
    callback = function()
        cursor_position = vim.api.nvim_win_get_cursor(0)
    end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("RestoreCursor", { clear = false }),
    callback = function()
        if vim.v.event.operator == "y" then
            vim.api.nvim_win_set_cursor(0, cursor_position)
        end
    end,
})

-- no comments next line
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        vim.cmd "set formatoptions-=cro"
    end,
})

-- templates
vim.api.nvim_create_autocmd("BufNewFile", {
    callback = function()
        local c_path = vim.fn.stdpath "config" .. "/templates/"
        local fe, ft = vim.fn.expand "%:e", vim.bo.filetype
        if ft == "make" then
            vim.cmd("0r " .. c_path .. "make") -- Makefile
        elseif ft == "cmake" then
            vim.cmd("0r " .. c_path .. "cmake") -- CMakeLists.txt
        elseif ft == "tex" then
            vim.cmd("0r " .. c_path .. "tex.tex") -- latex.tex
        end
    end,
})

-- scrollofftop padding
-- local ns_id = vim.api.nvim_create_namespace "top_padding_ns"
-- vim.api.nvim_create_autocmd({ "BufEnter", "VimResized" }, {
--     group = vim.api.nvim_create_augroup("TopPaddingGroup", { clear = true }),
--     callback = function()
--         if vim.bo.buftype == "terminal" then
--             return
--         end
--         local win_h = vim.api.nvim_win_get_height(0) - 1
--         local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
--         local virt_lines = {}
--         for _ = 1, off do
--             table.insert(virt_lines, { { "", "" } })
--         end
--         vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
--         vim.api.nvim_buf_set_extmark(0, ns_id, 0, 0, {
--             virt_lines = virt_lines,
--             virt_lines_above = true,
--             virt_lines_leftcol = true,
--         })
--     end,
-- })
--
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
--     group = vim.api.nvim_create_augroup("ScrollOffTop", {}),
--     callback = function(args)
--         local win_h = vim.api.nvim_win_get_height(0)
--         local view = vim.fn.winsaveview()
--         local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
--         local dist = view.lnum - view.topline
--         local n = math.max(0, off - dist - view.topfill - 1)
--         if n > 0 then
--             vim.schedule(function()
--                 if vim.bo.buftype == "terminal" then
--                     return
--                 end
--                 vim.print("scrolling " .. n .. " lines")
--                 vim.cmd("normal!" .. n .. vim.keycode "<c-y>")
--             end)
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("buffercdAU", {}),
    callback = function()
        local bcd = vim.fn.getcwd(-1, -1, 0)
        if bcd ~= "" then
            vim.cmd("lcd " .. bcd)
        end
    end,
})
