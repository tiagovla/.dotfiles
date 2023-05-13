local sources = require "mason-registry.sources"
require "plugins.modules.lsp.custom.pylance"
sources.set_registries { "lua:mason-registry.index" }
