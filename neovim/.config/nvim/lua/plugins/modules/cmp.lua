local M = {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "kdheepak/cmp-latex-symbols" },
        { "saadparwaiz1/cmp_luasnip" },
        { "zbirenbaum/copilot-cmp" },
        { "onsails/lspkind-nvim" },
        {
            "tiagovla/zotex.nvim",
            config = function()
                require("zotex").setup {}
            end,
            dependencies = { "kkharji/sqlite.lua" },
            dev = true,
        },
    },
}

function M.config()
    local cmp = require "cmp"
    local types = require "cmp.types"

    local mappings = {
        ["<Up>"] = { i = cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Select } },
        ["<Down>"] = { i = cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Select } },
        ["<C-n>"] = { i = cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Insert } },
        ["<C-p>"] = { i = cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Insert } },
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
            { "i", "c" }
        ),
        ["<c-space>"] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(_) -- fallback
                if cmp.visible() then
                    if not cmp.confirm { select = true } then
                        return
                    end
                else
                    cmp.complete()
                end
            end,
        },
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
    }

    cmp.setup.cmdline(":", {
        sources = {
            { name = "path" },
            { name = "nvim_lua" },
            { name = "cmdline", keyword_length = 2 },
        },
    })

    require("cmp").setup.cmdline("/", {
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
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "copilot" },
            { name = "path" },
            { name = "buffer", keyword_length = 5 },
            { name = "zotex" },
            { name = "latex_symbols" },
            { name = "nvim_lsp_signature_help" },
        },
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                function(entry1, entry2)
                    local _, entry1_under = entry1.completion_item.label:find "^_+"
                    local _, entry2_under = entry2.completion_item.label:find "^_+"
                    entry1_under = entry1_under or 0
                    entry2_under = entry2_under or 0
                    if entry1_under > entry2_under then
                        return false
                    elseif entry1_under < entry2_under then
                        return true
                    end
                end,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        experimental = {
            native_menu = false,
        },
    }
    require("copilot_cmp").setup {
        force_autofmt = true,
    }

    local lspkind = require "lspkind"
    lspkind.init {
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
            Copilot = "",
        },
    }
    cmp.setup {
        formatting = {
            format = lspkind.cmp_format {
                menu = {
                    luasnip = "[SNIP]",
                    buffer = "[BUF]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[LUA]",
                    path = "[PATH]",
                    latex_symbols = "[LaTeX]",
                    zotex = "[ZoTeX]",
                },
            },
        },
    }
end

return M
