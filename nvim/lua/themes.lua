local M = {}

local g = vim.g
local cmd = vim.cmd

function M.setup()
    M.tokyo_night()
    -- M.gruvbox()
    -- M.onedark()
    M.highlights()
end

function M.tokyo_night()
    cmd('colorscheme tokyonight')
    g.tokyonight_transparent_background = 1
    g.tokyonight_style = 'night'
    g.tokyonight_enable_italic = 1
end

function M.gruvbox() cmd('colorscheme gruvbox') end

function M.onedark() cmd('colorscheme onedark') end

function M.highlights()
    vim.cmd [[hi GitSignsAdd guifg=green guibg = none]]
    -- vim.cmd [[hi GitSignsAdd guifg=#81A1C1 guibg = none]]
    vim.cmd [[hi GitSignsChange guifg =#3A3E44 guibg = none]]
    vim.cmd [[hi GitSignsDelete guifg = #81A1C1 guibg = none]]
    vim.cmd [[hi LineNr guifg=#42464e guibg=NONE"]]
    vim.cmd [[hi Comment guifg=#42464e"]]
    vim.cmd [[hi SignColumn guibg=NONE"]]
    vim.cmd [[hi VertSplit guibg=NONE guifg=#2a2e36"]]
    vim.cmd [[hi EndOfBuffer guifg=#1e222a"]]
    vim.cmd [[hi PmenuSel guibg=#98c379"]]
    vim.cmd [[hi Pmenu  guibg=#282c34"]]
    vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
end
return M
