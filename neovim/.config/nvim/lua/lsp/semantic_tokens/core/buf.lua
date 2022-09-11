local util = require "vim.lsp.util"
local semantic_tokens = require "lsp.semantic_tokens.core.semantic_tokens"

local function request(method, params, handler)
    vim.validate {
        method = { method, "s" },
        handler = { handler, "f", true },
    }
    return vim.lsp.buf_request(0, method, params, handler)
end

function vim.lsp.buf.semantic_tokens_full()
    local params = { textDocument = util.make_text_document_params() }
    semantic_tokens._save_tick(vim.api.nvim_get_current_buf())
    return request("textDocument/semanticTokens/full", params)
end

function vim.lsp.buf.semantic_tokens_range()
    local params = util.make_given_range_params(nil, nil)
    semantic_tokens._save_tick()
    return request("textDocument/semanticTokens/range", params)
end
