require("plugins.modules.lsp.custom.pylance")
require("plugins.modules.lsp.custom.wolfram_ls")

local registry = {}
registry["pylance"] = "plugins.modules.lsp.custom.pylance"
-- registry["matlab-ls"] = "plugins.modules.lsp.custom.matlab-ls"

return registry
