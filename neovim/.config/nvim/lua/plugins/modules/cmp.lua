local M = {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp" },
        -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
        -- { "zbirenbaum/copilot-cmp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "kdheepak/cmp-latex-symbols" },
        { "saadparwaiz1/cmp_luasnip" },
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
        ["<Up>"] = { i = cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Insert } },
        ["<Down>"] = { i = cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Insert } },
        ["<C-n>"] = cmp.mapping(
            cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Select },
            { "i", "c" }
        ),
        ["<C-p>"] = cmp.mapping(
            cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Select },
            { "i", "c" }
        ),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
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
            -- { name = "copilot" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer", keyword_length = 7 },
            { name = "zotex" },
            { name = "latex_symbols" },
            -- { name = "nvim_lsp_signature_help" },
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
    -- require("copilot_cmp").setup {
    --     force_autofmt = true,
    -- }

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

local N = {
    {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {
            impersonate_nvim_cmp = true,
            debug = true,
        },
    },
    {
        "saghen/blink.cmp",
        version = "v0.10.0",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
            -- { "zbirenbaum/copilot-cmp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "kdheepak/cmp-latex-symbols" },
            -- { "onsails/lspkind-nvim" },
            {
                "tiagovla/zotex.nvim",
                config = function()
                    require("zotex").setup {}
                end,
                dependencies = { "kkharji/sqlite.lua" },
                dev = true,
            },
        },
        opts = {
            snippets = {
                preset = "luasnip",
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    require("luasnip").jump(direction)
                end,
            },
            keymap = {
                preset = "enter",
                cmdline = {
                    preset = "default",
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "latex_symbols", "zotex", "nvim_lua" },
                providers = {
                    nvim_lua = {
                        name = "nvim_lua",
                        module = "blink.compat.source",
                        score_offset = -3,
                        opts = {},
                    },
                    latex_symbols = {
                        name = "latex_symbols",
                        module = "blink.compat.source",
                        score_offset = -3,
                        opts = {},
                    },
                    zotex = {
                        name = "zotex",
                        module = "blink.compat.source",
                        score_offset = -3,
                        opts = {},
                    },
                },
                min_keyword_length = function(ctx)
                    return ctx.trigger.kind == "trigger_character" and 0 or 3
                end,
            },
            completion = {

                accept = {
                    auto_brackets = {
                        enabled = true,
                        override_brackets_for_filetypes = {
                            tex = { "{", "}" },
                        },
                    },
                },
                menu = {
                    min_width = 30,
                    scrolloff = 2,
                    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                    winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:FocusedSymbol,Search:None",
                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_icon" } },
                        components = {
                            source_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    if ctx.item.data and ctx.item.data.citation then
                                        return "[ZoTeX]"
                                    end
                                    local map = {
                                        luasnip = "[SNIP]",
                                        buffer = "[BUF]",
                                        lsp = "[LSP]",
                                        nvim_lua = "[LUA]",
                                        path = "[PATH]",
                                        latex_symbols = "[LaTeX]",
                                        zotex = "[ZoTeX]",
                                        snippets = "[SNIP]",
                                    }
                                    return map[ctx.item.source_id] or ctx.item.source_id
                                end,
                                highlight = "BlinkCmpSource",
                            },
                        },
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}

return N
