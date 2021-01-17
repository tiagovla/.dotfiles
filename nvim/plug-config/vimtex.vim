" http://manpages.ubuntu.com/manpages/trusty/man5/zathurarc.5.html
let g:latex_view_general_viewer = 'zathura'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0

" Ignore mappings
" let g:vimtex_mappings_enabled = 0

let g:vimtex_syntax_enabled = 0
let g:tex_flavor = 'latex'
let g:vimtex_log_ignore = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
        \ 'Token not allowed in a PDF string',
      \ ]
