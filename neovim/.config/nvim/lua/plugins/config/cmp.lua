local function config()
    local cmp = require "cmp"
    local types = require "cmp.types"
    local mapping = require "cmp.config.mapping"

    local mappings = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("luasnip").jumpable(1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-next", true, true, true), "")
            elseif require("neogen").jumpable(1) then
                vim.fn.feedkeys(
                    vim.api.nvim_replace_termcodes("<cmd>lua require('neogen').jump_next()<CR>", true, true, true),
                    ""
                )
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            elseif require("neogen").jumpable(-1) then
                vim.fn.feedkeys(
                    vim.api.nvim_replace_termcodes("<cmd>lua require('neogen').jump_prev()<CR>", true, true, true),
                    ""
                )
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<Down>"] = { i = mapping.select_next_item { behavior = types.cmp.SelectBehavior.Select } },
        ["<Up>"] = { i = mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Select } },
        ["<C-n>"] = { i = mapping.select_next_item { behavior = types.cmp.SelectBehavior.Insert } },
        ["<C-p>"] = { i = mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Insert } },
        ["<C-y>"] = { i = mapping.confirm { select = false } },
        ["<C-e>"] = { i = mapping.abort() },
    }

    local c_mappings = cmp.mapping.preset.cmdline()
    c_mappings["<Up>"] = c_mappings["<C-N>"]
    c_mappings["<Down>"] = c_mappings["<C-P>"]
    c_mappings["<Tab>"] = { c = mapping.confirm { select = false } }

    cmp.setup.cmdline(":", {
        mapping = c_mappings,
        sources = {
            { name = "path" },
            { name = "nvim_lua" },
            { name = "cmdline", keyword_length = 2 },
        },
    })

    require("cmp").setup.cmdline("/", {
        mapping = c_mappings,
        sources = {
            { name = "buffer", keyword_length = 5 },
        },
    })

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
        mapping = mappings,
        sources = {
            { name = "copilot" },
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
end

return {
    config = config,
}
