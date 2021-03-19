local U = {}

function U.map(mode, lhs, rhs, opts)
  local options = {nowait = true, noremap = true, silent = false}
  if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return U
