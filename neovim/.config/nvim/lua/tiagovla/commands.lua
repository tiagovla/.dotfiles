local function to_numpy_array(args)
    local bufnr = vim.api.nvim_get_current_buf()
    local i = (args.line1 or vim.api.nvim_buf_get_mark(bufnr, "<")[1]) - 1
    local e = args.line2 or vim.api.nvim_buf_get_mark(bufnr, ">")[1]
    local lines = vim.api.nvim_buf_get_lines(0, i, e, false)

    for k, line in ipairs(lines) do
        lines[k] = "    [" .. table.concat(vim.split(vim.trim(line):gsub("%s+", " "), " ", true), ", ") .. "],"
    end
    table.insert(lines, 1, "np.array([")
    table.insert(lines, "])")
    vim.api.nvim_buf_set_lines(0, i, e, true, lines)
end

local function redir(ctx)
    local lines = vim.split(vim.api.nvim_exec2(ctx.args, { output = true }).output, "\n", { plain = true })
    vim.cmd "new"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end

vim.api.nvim_create_user_command("NumpyArray", to_numpy_array, { range = true })
vim.api.nvim_create_user_command("Redir", redir, { nargs = "+", complete = "command" })

vim.api.nvim_create_user_command("Bdelete", function(args)
    local buf = vim.fn.bufnr(tonumber(args.args) or args.args)
    if buf == -1 then
        vim.notify("Buffer not found: " .. args.args, vim.log.levels.ERROR)
        return
    end
    Snacks.bufdelete.delete { buf = buf, force = args.bang }
end, { nargs = "?", bang = true, complete = "buffer", desc = "Delete a buffer and keep its windows" })

vim.cmd [[cnoreabbrev <expr> bd getcmdtype() == ':' && getcmdline() ==# 'bd' ? 'Bdelete' : 'bd']]
