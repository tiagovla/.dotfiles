local ezmap = require('ezmap')

local whichkey_mappings = {
    {"n", "<space>", [[:silent <c-u> :silent WhichKey '<space>' <CR>]]},
    {"v", "<space>", [[:silent <c-u> :silent WhichKeyVisual '<space>' <CR>]]}
}
ezmap.map(whichkey_mappings, {'noremap', 'silent'})
