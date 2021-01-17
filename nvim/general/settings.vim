set belloff=all
set tabstop=4 
set softtabstop=4 noexpandtab
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set smartcase
set noswapfile
set nu rnu
set incsearch
set ignorecase
set smartcase
set mouse=a
set list
set listchars=tab:!·,trail:·
set hidden
set scrolloff=8

set expandtab
set colorcolumn=80
" highlight ColorColumn ctermbg=0 guibg=lightgrey
highlight LineNr ctermfg=cyan ctermbg=yellow guifg=DarkGray
set clipboard=unnamedplus

let g:python3_host_prog = '~/.pyenv/versions/3.8.6/bin/python3'

set splitbelow
set splitright
" buffers
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
" panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

function! HLNext()
  let l:higroup = matchend(getline('.'), '\c'.@/, col('.')-1) == col('.')
              \ ? 'SpellRare' : 'IncSearch'
  let b:cur_match = matchadd(l:higroup, '\c\%#'.@/, 101)
  redraw
  augroup HLNext
    autocmd CursorMoved <buffer>
                \   execute 'silent! call matchdelete('.b:cur_match.')'
                \ | redraw
                \ | autocmd! HLNext
  augroup END
endfunction
nnoremap <silent> * *:call HLNext()<CR>
nnoremap <silent> # #:call HLNext()<CR>
nnoremap <silent> n n:call HLNext()<cr>
nnoremap <silent> N N:call HLNext()<cr>
