vim.pack.add {
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/saghen/blink.compat", version = "v2.5.0" },
    "https://github.com/onsails/lspkind-nvim",
}

require("blink.cmp").setup {
    fuzzy = {
        prebuilt_binaries = {
            force_version = "v1.*",
            download = true,
        },
    },
    enabled = function()
        return not vim.list_contains({ "DressingInput" }, vim.bo.filetype)
            and vim.bo.buftype ~= "prompt"
            and vim.b.completion ~= false
    end,
    keymap = {
        preset = "default",
    },
    snippets = {
        preset = "luasnip",
        expand = function(snippet)
            vim.notify("Expanding snippet: " .. snippet, vim.log.levels.DEBUG)
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
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {},
        min_keyword_length = function(ctx)
            return ctx.trigger.kind == "trigger_character" and 0 or 3
        end,
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            treesitter_highlighting = true,
            window = {
                min_width = 10,
                max_width = 80,
                max_height = 20,
                border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                winblend = 0,
                winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:FocusedSymbol,Search:None",
                scrollbar = true,
                direction_priority = {
                    menu_north = { "e", "w", "n", "s" },
                    menu_south = { "e", "w", "s", "n" },
                },
            },
        },
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
    signature = {
        enabled = true,
        trigger = {
            enabled = true,
            show_on_keyword = false,
            blocked_trigger_characters = {},
            blocked_retrigger_characters = {},
            show_on_trigger_character = true,
            show_on_insert = false,
            show_on_insert_on_trigger_character = true,
        },
        window = {
            min_width = 1,
            max_width = 100,
            max_height = 10,
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            winblend = 0,
            winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:FocusedSymbol,Search:None",
            scrollbar = false,
            direction_priority = { "n", "s" },
            treesitter_highlighting = true,
            show_documentation = true,
        },
    },
}
