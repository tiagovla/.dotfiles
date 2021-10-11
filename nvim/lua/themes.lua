local M = {}
local g, cmd = vim.g, vim.cmd

function M.tokyodark()
    g.tokyodark_transparent_background = true
    pcall(cmd, "colorscheme tokyodark")
end

function M.setup() M.tokyodark() end

M.setup()
