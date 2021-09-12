local cmp = require('cmp')
local mapping = require('plug-config.cmp.mappings')

cmp.setup({
    snippet = {expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end},
    mapping = mapping,
    sources = {
        {name = 'buffer'}, {name = 'nvim_lsp'}, {name = 'nvim_lua'},
        {name = 'latex_symbols'}, {name = "ultisnips"}, {name = 'path'}
    },
    completion = {completeopt = 'menu,menuone,noinsert'}
})
