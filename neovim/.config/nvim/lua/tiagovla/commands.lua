M = {}

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

function M.setup()
    vim.api.nvim_create_user_command("NumpyArray", to_numpy_array, { range = true })
end

M.setup()
