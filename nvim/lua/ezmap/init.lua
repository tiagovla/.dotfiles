local M = {}

local function map_(mappings, bufnr, default_opts)
    local fn
    if bufnr then
        fn = function(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
    else
        fn = vim.api.nvim_set_keymap
    end

    for _, m in pairs(mappings) do
        local mode, lhs, rhs, opts

        if vim.tbl_islist(m) then
            mode, lhs, rhs, opts = unpack(m)
        else
            mode, lhs, rhs, opts = unpack { m.mode, m.lhs, m.rhs, m.opts }
        end

        opts = opts or default_opts

        if vim.tbl_islist(opts) and not vim.tbl_isempty(opts) then
            local opts_ = {}
            for _, v in ipairs(opts) do
                opts_[v] = true
            end
            opts = opts_
        end
        fn(mode, lhs, rhs, opts or {})
    end
end

function M.map(mappings, default_opts)
    map_(mappings, nil, default_opts)
end

function M.map_buf(mappings, bufnr, default_opts)
    map_(mappings, bufnr, default_opts)
end

return M
