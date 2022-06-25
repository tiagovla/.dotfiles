local handlers = require "vim.lsp.handlers"
local semantic_tokens = require "lsp.semantic_tokens.core.semantic_tokens"

handlers["textDocument/semanticTokens/full"] = function(err, result, ctx, config)
    return semantic_tokens.on_full(err, result, ctx, config)
end

handlers["textDocument/semanticTokens/range"] = function(err, result, ctx, config)
    return semantic_tokens.on_range(err, result, ctx, config)
end

handlers["textDocument/semanticTokens/full/delta"] = function(err, result, ctx, config)
    return semantic_tokens.on_full_delta(err, result, ctx, config)
end

handlers["workspace/semanticTokens/refresh"] = function(err, result, ctx, config)
    return semantic_tokens.on_refresh(err, result, ctx, config)
end
