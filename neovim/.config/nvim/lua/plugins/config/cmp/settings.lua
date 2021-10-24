-- local mapping = require "tiagovla.plug_config.cmp.mappings"
local cmp = require "cmp"
if not _G.packer_plugins["cmp-buffer"].loaded then
    vim.cmd [[packadd cmp-buffer]]
    vim.cmd [[packadd cmp-nvim-lsp]]
    vim.cmd [[packadd cmp-nvim-lua]]
    vim.cmd [[packadd cmp-latex-symbols]]
    vim.cmd [[packadd cmp-path]]
end
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    },
    sources = {
        { name = "buffer", keyword_length = 5 },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "latex_symbols" },
        { name = "path" },
    },
    completion = { completeopt = "menu,menuone,noinsert" },
    experimental = {
        native_menu = false,
    },
}
