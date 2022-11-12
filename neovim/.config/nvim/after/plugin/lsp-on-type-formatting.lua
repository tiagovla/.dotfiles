local util = require "vim.lsp.util"

local function handler(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    util.apply_text_edits(result, ctx.bufnr, client.offset_encoding)
end

local function format_on_type()
    local client = vim.lsp.get_active_clients { name = "clangd" }
    local buf = vim.api.nvim_get_current_buf()
    if #client == 0 then
        return
    else
        client = client[1]
    end

    local params = util.make_formatting_params {}
    local cursor = vim.api.nvim_win_get_cursor(0)
    params.position = { line = cursor[1], character = cursor[2] }
    params.ch = "\n"
    client.request("textDocument/onTypeFormatting", params, handler, buf)
end

local ns = vim.api.nvim_create_namespace "onTypeFormatting"
local function handler_on_key(key)
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" and key == "\r" then
        if vim.bo[0].filetype == "cpp" then
            vim.pretty_print(key)
            format_on_type()
        end
    end
end

-- vim.on_key(handler_on_key, ns)
