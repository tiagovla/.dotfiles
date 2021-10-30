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

-- for k in pairs(package.loaded) do
--     if k:match ".*tiagovla.*" then
--         package.loaded[k] = nil
--     end
-- end

return M
