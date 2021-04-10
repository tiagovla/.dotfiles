local M = {}

local g = vim.g
local cmd = vim.cmd

function M.setup()
    M.tokyo_night()
    -- M.gruvbox()
    M.highlights()
end

function M.tokyo_night()
    cmd('colorscheme tokyonight')
    g.tokyonight_style = 'night'
    g.tokyonight_enable_italic = 1
end

function M.gruvbox() cmd('colorscheme gruvbox') end

function M.highlights()
    vim.cmd [[ highlight GitSignsAdd    guifg=green]]
    vim.cmd [[ highlight GitSignsChange guifg=blue]]
    vim.cmd [[ highlight GitSignsDelete guifg=red]]
end
return M
