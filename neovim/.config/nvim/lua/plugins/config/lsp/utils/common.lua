local autocmds = require "plugins.config.lsp.utils.autocmds"
local mappings = require "plugins.config.lsp.mappings"

M = {}

M.on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    mappings.setup(client.name)

    if client.server_capabilities.definitionProvider then
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end

    -- if client.server_capabilities.semanticTokensProvider ~= nil then
    --     autocmds.SemanticTokensAU()
    -- end

    if client.server_capabilities.documentHighlightProvider then
        autocmds.DocumentHighlightAU()
    end

    if client.server_capabilities.documentFormattingProvider then
        autocmds.DocumentFormattingAU()
    end
end

return M
