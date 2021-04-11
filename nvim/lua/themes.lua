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
    vim.cmd "highlight! VertSplit guibg=NONE guifg=#282c34"
end

function M.gruvbox() cmd('colorscheme gruvbox') end

function M.onedark() cmd('colorscheme onedark') end

function M.highlights()
    vim.cmd [[hi LineNr guifg=#42464e guibg=NONE]]
    vim.cmd [[hi Comment guifg=#42464e]]
    vim.cmd [[hi SignColumn guibg=NONE]]
    vim.cmd "highlight! VertSplit guibg=NONE guifg=#282c34"
    vim.cmd [[hi EndOfBuffer guifg=#1e222a]]
    vim.cmd [[hi PmenuSel guibg=#98c379]]
    vim.cmd [[hi Pmenu  guibg=#282c34]]
    vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
    vim.cmd [[highlight! StatusLineNC gui=underline guibg=NONE guifg=#383c44]]
    local ns = vim.api.nvim_create_namespace("hl-tokyonight")
    vim.api.nvim_set_hl(ns, "VertSlit", {fg="#FF0000"})
    vim.api.nvim__set_hl_ns(ns)
end
return M
