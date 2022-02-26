local util = require "vim.lsp.util"
local buf = require "vim.lsp.buf"
local validate = vim.validate

local function request(method, params, handler)
    validate {
        method = { method, "s" },
        handler = { handler, "f", true },
    }
    return vim.lsp.buf_request(0, method, params, handler)
end

-- vim.lsp._request_name_to_capability["textDocument/semanticTokens/full"] = "semantic_tokens_full"
-- vim.lsp._request_name_to_capability["textDocument/semanticTokens/full/delta"] = "semantic_tokens_full_delta"

function buf.semantic_tokens_full()
    local params = { textDocument = util.make_text_document_params() }
    require("lsp.semantic_tokens.core")._save_tick()
    return request("textDocument/semanticTokens/full", params)
end

function buf.semantic_tokens_range()
    local params = util.make_given_range_params(nil, nil)
    require("lsp.semantic_tokens.core")._save_tick()
    return request("textDocument/semanticTokens/range", params)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

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

require "lsp.semantic_tokens.handlers"
require("lsp.semantic_tokens.nvim-semantic-tokens").setup()
