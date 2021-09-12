local cmp = require('cmp')
local mappings = require('plug-config.cmp.mappings')

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

cmp.setup({
    snippet = {expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end},
    mappings = mappings,
    sources = {
        {name = 'buffer'}, {name = 'nvim_lsp'}, {name = 'nvim_lua'},
        {name = 'latex_symbols'}, {name = "ultisnips"}, {name = 'path'}
    },
    completion = {completeopt = 'menu,menuone,noinsert'}
})
