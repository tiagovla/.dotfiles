local M = { "tiagovla/tokyodark.nvim", lazy = false }

function M.config()
    vim.g.tokyodark_transparent_background = true

    require("tokyodark").colorscheme()
    local function replace_hl(group, val)
        vim.api.nvim_set_hl(0, group, val)
    end

    local tokyodark = require "tokyodark"
    tokyodark.colorscheme()

    replace_hl("LspInlayHint", { bg = "#1C1C2A", fg = "#9AA0A7" })
    replace_hl("@module", { link = "TSType" })
    replace_hl("@property", { link = "Identifier" })
    replace_hl("@variable", { fg = "#Afa8ea" })
    replace_hl("TelescopeBorder", { link = "TSType" })
    replace_hl("TelescopePromptBorder", { fg = "#4A5057" })
    replace_hl("TelescopePreviewBorder", { fg = "#4A5057" })
    replace_hl("TelescopeResultsBorder", { fg = "#4A5057" })
    replace_hl("FloatTitle", { link = "Blue" })
    replace_hl("CmpItemKindCopilot", { fg = "#6CC644" })
end

return M
