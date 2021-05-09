if not _G.packer_plugins['plenary.nvim'].loaded then vim.cmd [[packadd plenary.nvim]] end

require 'plug-config.gitsigns.settings'
