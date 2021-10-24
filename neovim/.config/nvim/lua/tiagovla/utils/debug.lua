local cmd = vim.cmd
M = {}

function M.debug()
    cmd [[
                function! SynGroup()
                    let l:s = synID(line('.'), col('.'), 1)
                    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
                endfun
            ]]
    cmd [[nmap <F10> :call SynGroup() <cr>]]
end

return M
