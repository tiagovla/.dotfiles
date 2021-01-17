set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_snippet = 'UltiSnips'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" python
" lua require'lspconfig'.pyls.setup{on_attach=require'completion'.on_attach}
lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
" lua require'lspconfig'.jedi_language_server.setup{on_attach=require'completion'.on_attach}

" latex
lua require'lspconfig'.texlab.setup{on_attach=require'completion'.on_attach}
