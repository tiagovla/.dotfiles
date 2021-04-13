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

function M.gruvbox()
    cmd('colorscheme gruvbox')
    cmd('hi! link LspDiagnosticsDefaultWarning Error')
end

function M.onedark() cmd('colorscheme onedark') end

function M.highlights()
    vim.api.nvim_exec([[
      augroup custom_theme_highlights
        autocmd!
        au ColorScheme * hi LspDiagnosticsDefaultError guifg=#b42d46
        au ColorScheme * hi LspDiagnosticsDefaultWarning guifg=#bb873a
        au ColorScheme * hi LspDiagnosticsDefaultInformation guifg=#487ef4
        au ColorScheme * hi LspDiagnosticsDefaultHint guifg=#5e34ad
        au ColorScheme * hi LineNr guifg=#42464e guibg=NONE
        au ColorScheme * hi Comment guifg=#42464e
        au ColorScheme * hi SignColumn guibg=NONE
        au ColorScheme * hi LineNr guifg=#42464e guibg=NONE
        au ColorScheme * hi VertSplit guibg=NONE guifg=#282c34
        au ColorScheme * hi EndOfBuffer guifg=#1e222a
        au ColorScheme * hi PmenuSel guibg=#98c379
        au ColorScheme * hi Pmenu  guibg=#282c34
        au ColorScheme * hi Normal guibg=NONE ctermbg=NONE
        au ColorScheme * highlight! StatusLineNC gui=underline guibg=NONE guifg=#383c44
        augroup END
    ]], false)
end
return M
