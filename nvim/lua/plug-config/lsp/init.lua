if not _G.packer_plugins['nvim-lspconfig'].loaded then vim.cmd [[packadd nvim-lspconfig]] end
require 'plug-config.lsp.settings'
require 'plug-config.lsp.mappings'
