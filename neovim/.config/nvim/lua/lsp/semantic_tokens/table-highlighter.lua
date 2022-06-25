local M = {}

local presets = require "lsp.semantic_tokens.presets"
M.token_map = presets.token_map
M.modifiers_map = presets.modifiers_map

local token_cache
local modifiers_cache

--- transforms a highlight group string or a table of highlight group strings
local function define_prefixed_hl(ft, hl)
    local prefixed
    if type(hl) == "table" then
        prefixed = {}
        for k, sub_hl in pairs(hl) do
            prefixed[k] = define_prefixed_hl(ft, sub_hl)
        end
    else
        prefixed = ft .. hl
        vim.cmd("highlight default link " .. prefixed .. " " .. hl)
    end
    return prefixed
end

local function make_cache(base_map)
    -- two-stage look-up: ft-> token -> highlight
    -- two-stage look-up: ft-> modifier -> highlight (or per-token table for three stage look-up)
    return setmetatable({}, {
        __index = function(ft_cache, ft)
            local rtn = setmetatable({}, {
                __index = function(hl_cache, query)
                    local hl = base_map[query]
                    if hl then
                        local prefixed = define_prefixed_hl(ft, hl)
                        rawset(hl_cache, query, prefixed)
                        return prefixed
                    end
                    return hl
                end,
            })
            rawset(ft_cache, ft, rtn)
            return rtn
        end,
    })
end

function M.reset()
    token_cache = make_cache(M.token_map)
    modifiers_cache = make_cache(M.modifiers_map)
end

function M.highlight_token(ctx, token, highlight)
    local buf = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    local ft_token_cache = token_cache[ft]
    local ft_modifiers_cache = modifiers_cache[ft]

    local hl = ft_token_cache[token.type]

    if hl then
        highlight(hl)
    end
    for _, m in pairs(token.modifiers) do
        hl = ft_modifiers_cache[m]
        -- modifiers can have a per-type mapping
        -- e.g. readonly = { variable = "ReadOnlyVariable" }
        if type(hl) == "table" then
            hl = hl[token.type]
        end
        if hl then
            highlight(hl)
        end
    end
end

return M
