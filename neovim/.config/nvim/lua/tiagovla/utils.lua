local U = {}

function U.buf_is_valid(buf_num)
    if not buf_num or buf_num < 1 then
        return false
    end
    local exists = vim.api.nvim_buf_is_valid(buf_num)
    return vim.bo[buf_num].buflisted and exists
end

function U.get_valid_buffers()
    local buf_nums = vim.api.nvim_list_bufs()
    local ids = {}
    for _, buf in ipairs(buf_nums) do
        if U.buf_is_valid(buf) then
            ids[#ids + 1] = buf
        end
    end
    return ids
end

function U.buf_has_name(buf)
    return vim.api.nvim_buf_get_name(buf) ~= ""
end

-- function U.debug()
--     vim.cmd [[
--                 function! SynGroup()
--                     let l:s = synID(line('.'), col('.'), 1)
--                     echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
--                 endfun
--             ]]
--     vim.cmd [[nmap <F10> :call SynGroup() <cr>]]
-- end

return U
