local M = { "tiagovla/tokyodark.nvim", lazy = false, dev = true }

function M.config()
    vim.g.tokyodark_transparent_background = true
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            local function replace_hl(group, val)
                vim.api.nvim_set_hl(0, group, val)
            end
            replace_hl("LspInlayHint", { bg = "#1C1C2A", fg = "#9AA0A7" })
            replace_hl("@module", { link = "TSType" })
            replace_hl("@property", { link = "Identifier" })
            replace_hl("@variable", { fg = "#Afa8ea" })
            replace_hl("FloatTitle", { link = "Blue" })
            replace_hl("TelescopeBorder", { link = "TSType" })
            replace_hl("TelescopePreviewBorder", { fg = "#4A5057" })
            replace_hl("TelescopePreviewTitle", { link = "Blue" })
            replace_hl("TelescopePromptBorder", { fg = "#4A5057" })
            replace_hl("TelescopePromptTitle", { link = "Blue" })
            replace_hl("TelescopeResultsBorder", { fg = "#4A5057" })
            replace_hl("TelescopeResultsTitle", { link = "Blue" })
            replace_hl("CmpItemKindCopilot", { fg = "#6CC644" })
        end,
    })
    require("tokyodark").colorscheme()
end

return M
