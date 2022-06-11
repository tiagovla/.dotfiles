local function config()
    local function replace_hl(group, val)
        vim.api.nvim_set_hl(0, group, val)
    end

    local semantic_tokens_highlights = {
        LspNamespace = "TSNamespace",
        LspModule = "Variable",
        LspType = "TSType",
        LspClass = "LspType",
        LspEnum = "TSEnum",
        LspInterface = "TSInterface",
        LspStruct = "TSStruct",
        LspTypeParameter = "TSParameter",
        LspParameter = "TSParameter",
        LspVariable = "TSVariable",
        LspProperty = "TSProperty",
        LspEnumMember = "TSEnumMember",
        LspEvent = "TSEvent",
        LspFunction = "TSFunction",
        LspMethod = "TSMethod",
        LspMacro = "Special",
        LspKeyword = "TSKeyword",
        LspModifier = "TSModifier",
        LspComment = "TSComment",
        LspString = "TSString",
        LspNumber = "TSNumber",
        LspBoolean = "TSBoolean",
        LspRegexp = "TSStringRegex",
        LspOperator = "TSOperator",
        LspDecorator = "TSSymbol",
        LspDeprecated = "TSStrike",
    }

    local tokyodark = require "tokyodark"
    tokyodark.colorscheme()

    replace_hl("LspClass", { link = "TSType" })
    replace_hl("TSVariable", { fg = "#Afa8ea" })
    replace_hl("TelescopeBorder", { link = "TSType" })
    replace_hl("TelescopePromptBorder", { fg = "#4A5057" })
    replace_hl("TelescopePreviewBorder", { fg = "#4A5057" })
    replace_hl("TelescopeResultsBorder", { fg = "#4A5057" })

    for k, v in pairs(semantic_tokens_highlights) do
        replace_hl(k, { link = v })
    end
end

return {
    config = config,
}
