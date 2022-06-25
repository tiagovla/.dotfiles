local extensions = {}

local inlay_hints = require "lsp.inlay_hints.core"

extensions.inlay_hints = inlay_hints.set_inlay_hints
extensions.setup_autocmd = inlay_hints.setup_autocmd

return extensions
