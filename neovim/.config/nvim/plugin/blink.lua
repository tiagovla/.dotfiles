vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.1" },
    "https://github.com/hrsh7th/cmp-nvim-lua",
    "https://github.com/kdheepak/cmp-latex-symbols",
    "https://github.com/onsails/lspkind-nvim",
    "https://github.com/saghen/blink.compat",
}, { confirm = false })

-- require("blink.compat").setup {
--     impersonate_nvim_cmp = true,
--     debug = true,
-- }

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
        default = { "lsp", "path", "snippets", "buffer", "latex_symbols", "nvim_lua" },
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
}
