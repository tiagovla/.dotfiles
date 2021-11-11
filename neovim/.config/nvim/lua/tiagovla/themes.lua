local M = {}

function M.tokyodark()
    vim.g.tokyodark_transparent_background = true
    local ok, tokyodark = pcall(require, "tokyodark")
    if ok then
        tokyodark.colorscheme()
    end
end

function M.setup()
    M.tokyodark()
end

M.setup()

local function replace_hl(group, val)
    local ns = vim.api.nvim_create_namespace "tokyodark"
    vim.api.nvim_set_hl(ns, group, val)
end

-- replace_hl("StatusLineNC", { --...--})
