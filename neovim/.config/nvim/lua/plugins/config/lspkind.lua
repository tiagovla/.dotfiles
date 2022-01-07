local function config()
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

    local ok, cmp = pcall(require, "cmp")
    if not ok then
        return
    end
    local lspkind = require "lspkind"

    cmp.setup {
        formatting = {
            format = lspkind.cmp_format {
                with_text = true,
                menu = {
                    luasnip = "[SNIP]",
                    buffer = "[BUF]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[LUA]",
                    path = "[PATH]",
                    latex_symbols = "[LaTeX]",
                },
            },
        },
    }
end

return {
    config = config,
    after = "nvim-cmp",
}
