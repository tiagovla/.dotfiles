-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
    callback = function()
        if vim.v.event.operator == "y" then
            vim.hl.hl_op { higroup = "IncSearch", timeout = 300 }
        end
    end,
})

-- keep cursor position after yanking
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufEnter", "CursorMoved" }, {
    group = vim.api.nvim_create_augroup("RestoreCursor", {}),
    callback = function()
        vim.w.yank_restore_cursor = {
            bufnr = vim.api.nvim_get_current_buf(),
            position = vim.api.nvim_win_get_cursor(0),
        }
    end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("RestoreCursor", { clear = false }),
    callback = function()
        local saved = vim.w.yank_restore_cursor
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.v.event.operator == "y" and saved and saved.bufnr == bufnr then
            local row = math.min(saved.position[1], vim.api.nvim_buf_line_count(bufnr))
            local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
            vim.api.nvim_win_set_cursor(0, { row, math.min(saved.position[2], #line) })
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
        local _, ft = vim.fn.expand "%:e", vim.bo.filetype
        if ft == "make" then
            vim.cmd("0r " .. c_path .. "make") -- Makefile
        elseif ft == "cmake" then
            vim.cmd("0r " .. c_path .. "cmake") -- CMakeLists.txt
        elseif ft == "tex" then
            vim.cmd("0r " .. c_path .. "tex.tex") -- latex.tex
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("buffercdAU", {}),
    callback = function()
        local bcd = vim.fn.getcwd(-1, -1, 0)
        if bcd ~= "" then
            vim.cmd("lcd " .. bcd)
        end
    end,
})
