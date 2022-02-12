local M = {}

local semantic_tokens = setmetatable({}, {
    __index = function(table, key)
        local rtn = {}
        rawset(table, key, rtn)
        return rtn
    end,
})
local last_result_id = setmetatable({}, {
    __index = function(table, key)
        local rtn = {}
        rawset(table, key, rtn)
        return rtn
    end,
})

local validate = vim.validate
local function request(method, params, handler)
    validate {
        method = { method, "s" },
        handler = { handler, "f", true },
    }
    return vim.lsp.buf_request(0, method, params, handler)
end

local buf = require "vim.lsp.buf"
local util = require "vim.lsp.util"
function buf.semantic_tokens_full_delta()
    local params = { textDocument = util.make_text_document_params() }
    local buf = vim.api.nvim_get_current_buf()
    params.previousResultId = last_result_id[buf]
    print(vim.inspect(params))
    require("plugins.config.lsp.semantic_tokens.core")._save_tick()
    return request("textDocument/semanticTokens/full/delta", params)
end

local last_tick = {}
local active_requests = {}

---@private
local function get_bit(n, k)
    --todo(theHamsta): remove once `bit` module is available for non-LuaJIT
    if _G.bit then
        return _G.bit.band(_G.bit.rshift(n, k), 1)
    else
        return (n / math.pow(2, k)) % 2
    end
end

---@private
local function modifiers_from_number(x, modifiers_table)
    local modifiers = {}
    for i = 0, #modifiers_table - 1 do
        local bit = get_bit(x, i)
        if bit == 1 then
            table.insert(modifiers, 1, modifiers_table[i + 1])
        end
    end

    return modifiers
end

--- |lsp-handler| for the method `textDocument/semanticTokens/full`
---
--- This function can be configured with |vim.lsp.with()| with the following options for `config`
---
--- `on_token`: A function with signature `function(ctx, token)` that is called
---             whenever a semantic token is received from the server from context `ctx`
---             (see |lsp-handler| for the definition of `ctx`). This can be used for highlighting the tokens.
---             `token` is a table:
---
--- <pre>
---   {
---         line       -- line number 0-based
---         start_char -- start character 0-based
---         length     -- length in characters of this token
---         type       -- token type as string (see https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#semantic-token-classification)
---         modifiers  -- token modifier as string (see https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#semantic-token-classification)
---   }
--- </pre>
---
--- `on_invalidate_range`: A function with signature `function(ctx, line_start, line_end)` called whenever tokens
---                        in a specific line range (`line_start`, `line_end`) should be considered invalidated
---                        (see |lsp-handler| for the definition of `ctx`). `line_end` can be -1 to
---                        indicate invalidation until the end of the buffer.
function M.on_full(err, response, ctx, config)
    if not ctx.bufnr or not ctx.client_id then
        return
    end
    active_requests[ctx.bufnr] = false
    if config and config.on_invalidate_range then
        config.on_invalidate_range(ctx, 0, -1)
    end
    -- if tick has changed our response is outdated!
    if err or last_tick[ctx.bufnr] ~= vim.api.nvim_buf_get_changedtick(ctx.bufnr) then
        semantic_tokens[ctx.bufnr][ctx.client_id] = {}
        return
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return
    end
    local legend = client.server_capabilities.semanticTokensProvider.legend
    local token_types = legend.tokenTypes
    local token_modifiers = legend.tokenModifiers
    local data = response.data
    local result_id = response.resultId

    local tokens = {}
    local line, start_char = nil, 0
    for i = 1, #data, 5 do
        local delta_line = data[i]
        line = line and line + delta_line or delta_line
        local delta_start = data[i + 1]
        start_char = delta_line == 0 and start_char + delta_start or delta_start

        -- data[i+3] +1 because Lua tables are 1-indexed
        local token_type = token_types[data[i + 3] + 1]
        local modifiers = modifiers_from_number(data[i + 4], token_modifiers)

        local token = {
            line = line,
            start_char = start_char,
            length = data[i + 2],
            type = token_type,
            modifiers = modifiers,
        }
        tokens[line + 1] = tokens[line + 1] or {}
        table.insert(tokens[line + 1], token)

        if token_type and config and config.on_token then
            config.on_token(ctx, token)
        end
    end

    semantic_tokens[ctx.bufnr][ctx.client_id] = tokens
    last_result_id[ctx.bufnr] = result_id
end

function M.on_full_delta(err, response, ctx, config)
    if response then
        print(vim.inspect(response))
        local result_id = response.resultId
        last_result_id[ctx.bufnr] = result_id
    end
end

function M.on_range(err, response, ctx, config)
    print(response)
    if response then
        print(vim.inspect(response))
    end
end

--- |lsp-handler| for the method `textDocument/semanticTokens/refresh`
---
function M.on_refresh(err, _, ctx, _)
    if not err then
        M.refresh(ctx.bufnr)
    end
    return vim.NIL
end

---@private
function M._save_tick(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    last_tick[bufnr] = vim.api.nvim_buf_get_changedtick(bufnr)
    active_requests[bufnr] = true
end

--- Get currently active semantic tokens
---
--- @param bufnr number|nil
--- @param client_id number|nil
function M.get(bufnr, client_id)
    if not bufnr then
        return semantic_tokens
    elseif not client_id then
        return semantic_tokens[bufnr]
    else
        return semantic_tokens[bufnr][client_id]
    end
end

--- Refresh the semantic tokens for the current buffer
---
--- It is recommended to trigger this using an autocmd or via keymap.
---
--- <pre>
---   autocmd BufEnter,CursorHold,InsertLeave <buffer> lua require 'vim.lsp.semantic_tokens'.refresh()
--- </pre>
---
--- @param bufnr number|nil
function M.refresh(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not active_requests[bufnr] then
        local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
        bufnr = vim.api.nvim_get_current_buf()
        if not last_tick[bufnr] or last_tick[bufnr] < vim.api.nvim_buf_get_changedtick(bufnr) then
            M._save_tick(bufnr)
            vim.lsp.buf_request(bufnr, "textDocument/semanticTokens/full", params)
        end
    end
end

return M
