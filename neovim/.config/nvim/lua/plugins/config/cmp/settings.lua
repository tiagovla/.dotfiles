local mapping = require "plugins.config.cmp.mappings"
local cmp = require "cmp"

cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        documentation = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:FocusedSymbol,Search:None",
        },
        completion = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:FocusedSymbol,Search:None",
        },
    },
    mapping = mapping,
    sources = {
        { name = "path" },
        { name = "zotex" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua" },
        { name = "latex_symbols" },
        { name = "buffer", keyword_length = 5 },
    },
    completion = { completeopt = "menu,menuone,noinsert" },
    experimental = {
        native_menu = false,
    },
}
