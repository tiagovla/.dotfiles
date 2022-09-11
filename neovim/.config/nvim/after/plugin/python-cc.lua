-- Logic to parse pyproject.toml and set colorcolumn
--
local function file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    end
    return f ~= nil
end

local function lines_from(file)
    if not file_exists(file) then
        return {}
    end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

local function get_root(bufnr, ft)
    local parser = vim.treesitter.get_parser(bufnr, ft, {})
    local tree = parser:parse()[1]
    return tree:root()
end

local function get_black_length(bufnr)
    local query = vim.treesitter.parse_query(
        "toml",
        [[
            (table
              (dotted_key) @dotkey (#eq? @dotkey "tool.black")
              (pair
                (bare_key) @barekey (#eq? @barekey "line-length")
                (integer) @length
              )
            )
        ]]
    )
    local root = get_root(bufnr, "toml")
    for id, node in query:iter_captures(root, bufnr, 0, -1) do
        local name = query.captures[id]
        if name == "length" then
            return vim.treesitter.get_node_text(node, bufnr)
        end
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf

        if vim.bo[buffer].ft ~= "python" then
            return
        end
        local file_name = "pyproject.toml"
        local tmp_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, lines_from(file_name))
        local length = get_black_length(tmp_buf)
        vim.opt_local.colorcolumn = tostring(length or "88")
        vim.api.nvim_buf_delete(tmp_buf, {})
    end,
})
