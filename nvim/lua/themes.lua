local M = {}

local b = vim.bo
local g = vim.g
local o = vim.o
local w = vim.wo
local cmd = vim.cmd

function M.setup()
  M.tokyo_night()
end

function M.tokyo_night()
  cmd('colorscheme tokyonight')
  g.tokyonight_style = 'night'
  g.tokyonight_enable_italic = 1
end

return M
