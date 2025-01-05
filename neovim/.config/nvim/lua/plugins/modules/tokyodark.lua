return {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    dev = true,
    priority = 1000,
    opts = {
        transparent_background = true,
        custom_highlights = function(hl, p)
            return {
                ["LspInlayHint"] = { bg = "#1C1C2A", fg = "#9AA0A7" },
                -- ["Conceal"] = { bg = "NONE" },
                ["@module"] = { link = "TSType" },
                ["@property"] = { link = "Identifier" },
                ["@variable"] = { fg = "#Afa8ea" },
                ["@lsp.type.variable"] = { fg = "#Afa8ea" },
                ["@module.latex"] = { link = "Red" },
                ["@markup.link.latex"] = { link = "Blue" },
                ["CmpItemKindCopilot"] = { fg = "#6CC644" },
                NoiceLspProgressSpinner = { bg = "#1C1C2A" },
                NoiceLspProgressClient = { bg = "#1C1C2A" },
                NoiceLspProgressTitle = { bg = "#1C1C2A" },
                NoiceMini = { bg = "#1C1C2A" },
                NoiceCmdlineIconSearch = { link = "Blue" },
            }
        end,
    },
    config = function(_, opts)
        require("tokyodark").setup(opts)
        require("tokyodark").colorscheme()
    end,
}
