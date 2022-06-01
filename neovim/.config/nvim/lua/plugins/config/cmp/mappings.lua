local cmp = require "cmp"
local mapping = require "cmp.config.mapping"
local types = require "cmp.types"
local ls = require "luasnip"

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

return mappings
