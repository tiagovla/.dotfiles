let g:matlab_auto_mappings = 0
let g:matlab_server_launch = 'tmux'
let g:matlab_server_split = 'horizontal'


augroup filetypedetect
    au! BufRead,BufNewFile,BufWrite,BufWritePre,BufWritePost *.m setfiletype matlab
augroup END


" if g:matlab_auto_mappings
"   nnoremap <buffer>         <leader>rn :MatlabRename
"   nnoremap <buffer><silent> <leader>fn :MatlabFixName<CR>
"   vnoremap <buffer><silent> <C-m> <ESC>:MatlabCliRunSelection<CR>
"   nnoremap <buffer><silent> <C-m> <ESC>:MatlabCliRunCell<CR>
"   nnoremap <buffer><silent> <C-h> :MatlabCliRunLine<CR>
"   nnoremap <buffer><silent> ,i <ESC>:MatlabCliViewVarUnderCursor<CR>
"   vnoremap <buffer><silent> ,i <ESC>:MatlabCliViewSelectedVar<CR>
"   nnoremap <buffer><silent> ,h <ESC>:MatlabCliHelp<CR>
"   nnoremap <buffer><silent> ,e <ESC>:MatlabCliOpenInMatlabEditor<CR>
"   nnoremap <buffer><silent> <leader>c :MatlabCliCancel<CR>
"   nnoremap <buffer><silent> <C-l> :MatlabNormalModeCreateCell<CR>
"   vnoremap <buffer><silent> <C-l> :<C-u>MatlabVisualModeCreateCell<CR>
"   inoremap <buffer><silent> <C-l> <C-o>:MatlabInsertModeCreateCell<CR>
" endif
