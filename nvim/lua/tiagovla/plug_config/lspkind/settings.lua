require("lspkind").init {
    with_text = true,
    symbol_map = {
        Text = "",
        Method = "ƒ",
        Function = "",
        Constructor = "",
        Variable = "[]",
        Class = "  ",
        Interface = "ﰮ",
        Module = "",
        Property = "",
        Unit = " 塞 ",
        Value = "  ",
        Enum = " 練",
        Keyword = "",
        Snippet = "﬌",
        Color = "",
        File = "",
        Folder = " ﱮ ",
        EnumMember = "  ",
        Constant = "",
        Struct = "  ",
    },
}

local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            return vim_item
        end,
    },
}
