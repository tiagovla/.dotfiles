local M = {
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "hrsh7th/cmp-nvim-lua" },
            { "kdheepak/cmp-latex-symbols" },
            { "onsails/lspkind-nvim" },
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
                "tiagovla/zotex.nvim",
                config = function()
                    require("zotex").setup {}
                end,
                dependencies = { "kkharji/sqlite.lua" },
                dev = true,
            },
        },
        opts = {
            enabled = function()
                return not vim.list_contains({ "DressingInput" }, vim.bo.filetype)
                    and vim.bo.buftype ~= "prompt"
                    and vim.b.completion ~= false
            end,
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
            cmdline = {
                keymap = {
                    preset = "enter",
                    ["<Tab>"] = { "show_and_insert", "select_next" },
                    ["<S-Tab>"] = { "show_and_insert", "select_prev" },
                    ["<CR>"] = { "accept_and_enter", "fallback" },
                },
                sources = function()
                    return vim.fn.getcmdtype() == ":" and { "cmdline" } or {}
                end,
                completion = {
                    menu = {
                        auto_show = function(ctx)
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
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

return M
