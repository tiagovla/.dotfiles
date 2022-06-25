local capabilities = vim.lsp.protocol.make_client_capabilities()

-- vim.lsp._request_name_to_capability["textDocument/semanticTokens/full"] = {"semantic_tokens_full"}
-- vim.lsp._request_name_to_capability["textDocument/semanticTokens/full/delta"] = "semantic_tokens_full_delta"

local function make_client_capabilities()
    capabilities.textDocument.semanticTokens = {
        dynamicRegistration = false,
        tokenTypes = {
            "namespace",
            "type",
            "class",
            "enum",
            "interface",
            "struct",
            "typeParameter",
            "parameter",
            "variable",
            "property",
            "enumMember",
            "event",
            "function",
            "method",
            "macro",
            "keyword",
            "modifier",
            "comment",
            "string",
            "number",
            "regexp",
            "operator",
        },
        tokenModifiers = {
            "declaration",
            "definition",
            "readonly",
            "static",
            "deprecated",
            "abstract",
            "async",
            "modification",
            "documentation",
            "defaultLibrary",
        },
        formats = { "relative" },
        requests = {
            -- range = false,
            full = { delta = false },
        },

        overlappingTokenSupport = true,
        multilineTokenSupport = false,
    }
    return capabilities
end

vim.lsp.protocol.make_client_capabilities = make_client_capabilities
