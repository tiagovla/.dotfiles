return {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    dev = true,
    priority = 1000,
    config = function()
        vim.g.tokyodark_transparent_background = true
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                local function hl(...)
                    vim.api.nvim_set_hl(0, ...)
                end
                hl("LspInlayHint", { bg = "#1C1C2A", fg = "#9AA0A7" })
                hl("@module", { link = "TSType" })
                hl("@property", { link = "Identifier" })
                hl("@variable", { fg = "#Afa8ea" })
                hl("FloatTitle", { link = "Blue" })
                hl("TelescopeBorder", { link = "TSType" })
                hl("TelescopePreviewBorder", { fg = "#4A5057" })
                hl("TelescopePreviewTitle", { link = "Blue" })
                hl("TelescopePromptBorder", { fg = "#4A5057" })
                hl("@lsp.type.variable", {})
                hl("TelescopePromptTitle", { link = "Blue" })
                hl("TelescopeResultsBorder", { fg = "#4A5057" })
                hl("TelescopeResultsTitle", { link = "Blue" })
                hl("CmpItemKindCopilot", { fg = "#6CC644" })
                hl("NoiceLspProgressSpinner", { bg = "#1C1C2A" })
                hl("NoiceLspProgressClient", { bg = "#1C1C2A" })
                hl("NoiceLspProgressTitle", { bg = "#1C1C2A" })
                hl("NoiceMini", { bg = "#1C1C2A" })
                hl("NoiceCmdlineIconSearch", { link = "Blue" })
            end,
        })
        vim.cmd.colorscheme "tokyodark"
    end,
}
