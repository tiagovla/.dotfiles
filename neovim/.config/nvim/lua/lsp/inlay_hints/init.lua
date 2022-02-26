local vim = vim
local extensions = {}

local inlay_hints = require "lsp.inlay_hints.core"

extensions.inlay_hints = function(opts)
    vim.lsp.buf_request(0, "rust-analyzer/inlayHints", inlay_hints.get_params(), inlay_hints.get_callback(opts))
end

return extensions
