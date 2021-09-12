local ezmap = require("ezmap")
local cmp = require('cmp')

local mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
    }),
    ["<C-Space>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
            if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                return vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
            end

            vim.fn.feedkeys(t("<C-n>"), "n")
        elseif check_back_space() then
            vim.fn.feedkeys(t("<cr>"), "n")
        else
            fallback()
        end
    end, {"i", "s"}),
    ["<Tab>"] = cmp.mapping(function(fallback)
        if vim.fn.complete_info()["selected"] == -1 and
            vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            vim.fn.feedkeys(t("<ESC>:call UltiSnips#JumpForwards()<CR>"))
        elseif vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-n>"), "n")
        elseif check_back_space() then
            vim.fn.feedkeys(t("<tab>"), "n")
        else
            fallback()
        end
    end, {"i", "s"}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"))
        elseif vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-p>"), "n")
        else
            fallback()
        end
    end, {"i", "s"})
}

return mapping

