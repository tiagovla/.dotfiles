if not _G.packer_plugins['plenary.nvim'].loaded then
    vim.cmd [[packadd plenary.nvim]]
    vim.cmd [[packadd popup.nvim]]
    vim.cmd [[packadd telescope-media-files.nvim]]
end

require 'plug-config.telescope.settings'
require 'plug-config.telescope.mappings'
