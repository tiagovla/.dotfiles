-- https://github.com/neovim/neovim/pull/15723
require "lsp.semantic_tokens.core.handlers"
require "lsp.semantic_tokens.core.buf"
require "lsp.semantic_tokens.core.protocol"

-- https://github.com/theHamsta/nvim-semantic-tokens
require("lsp.semantic_tokens.plugin.nvim_semantic_tokens").setup()
