-- https://github.com/simrat39/rust-tools.nvim
local M = {}
local utils = require "lsp.inlay_hints.utils"
local config = require "lsp.inlay_hints.config"

function M.setup_autocmd()
    local events = "BufEnter,BufWinEnter,TabEnter,BufWritePost,CursorMoved,InsertLeave"
    if config.options.tools.inlay_hints.only_current_line then
        events = string.format("%s,%s", events, config.options.tools.inlay_hints.only_current_line_autocmd)
    end
    local group = vim.api.nvim_create_augroup("InlayHints", {})
    vim.api.nvim_create_autocmd(vim.split(events,","), {
        group = group,
        buffer = 0,
        callback = function()
            require("lsp.inlay_hints").inlay_hints()
        end,
    })
end

local function get_params()
    return { textDocument = vim.lsp.util.make_text_document_params() }
end

local namespace = vim.api.nvim_create_namespace "experimental/inlayHints"
local enabled = nil

local function parseHints(result)
    local map = {}
    local only_current_line = config.options.tools.inlay_hints.only_current_line

    if type(result) ~= "table" then
        return {}
    end
    for _, value in pairs(result) do
        local range = value.position
        local line = value.position.line
        local label = value.label
        local kind = value.kind
        local current_line = vim.api.nvim_win_get_cursor(0)[1]

        local function add_line()
            if map[line] ~= nil then
                table.insert(map[line], { label = label, kind = kind, range = range })
            else
                map[line] = { { label = label, kind = kind, range = range } }
            end
        end

        if only_current_line then
            if line == tostring(current_line - 1) then
                add_line()
            end
        else
            add_line()
        end
    end
    return map
end

local function get_max_len(bufnr, parsed_data)
    local max_len = -1

    for key, _ in pairs(parsed_data) do
        local line = tonumber(key)
        local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
        if current_line then
            local current_line_len = string.len(current_line)
            max_len = math.max(max_len, current_line_len)
        end
    end

    return max_len
end

local function handler(err, result, ctx)
    if err then
        return
    end
    local opts = config.options.tools.inlay_hints
    local bufnr = ctx.bufnr

    if vim.api.nvim_get_current_buf() ~= bufnr then
        return
    end

    -- clean it up at first
    M.disable_inlay_hints()

    local parsed = parseHints(result)

    for key, value in pairs(parsed) do
        local virt_text = ""
        local line = tonumber(key)

        local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]

        if current_line then
            local current_line_len = string.len(current_line)

            local param_hints = {}
            local other_hints = {}

            -- segregate paramter hints and other hints
            for _, value_inner in ipairs(value) do
                if value_inner.kind == 2 then
                    table.insert(param_hints, value_inner.label)
                end

                if value_inner.kind == 1 then
                    table.insert(other_hints, value_inner)
                end
            end

            -- show parameter hints inside brackets with commas and a thin arrow
            if not vim.tbl_isempty(param_hints) and opts.show_parameter_hints then
                virt_text = virt_text .. opts.parameter_hints_prefix .. "("
                for i, value_inner_inner in ipairs(param_hints) do
                    virt_text = virt_text .. value_inner_inner:sub(1, -2)
                    if i ~= #param_hints then
                        virt_text = virt_text .. ", "
                    end
                end
                virt_text = virt_text .. ") "
            end

            -- show other hints with commas and a thicc arrow
            if not vim.tbl_isempty(other_hints) then
                virt_text = virt_text .. opts.other_hints_prefix
                for i, value_inner_inner in ipairs(other_hints) do
                    if value_inner_inner.kind == 2 and opts.show_variable_name then
                        local char_start = value_inner_inner.range.start.character
                        local char_end = value_inner_inner.range["end"].character
                        local variable_name = string.sub(current_line, char_start + 1, char_end)
                        virt_text = virt_text .. variable_name .. ": " .. value_inner_inner.label
                    else
                        if string.sub(value_inner_inner.label, 1, 2) == ": " then
                            virt_text = virt_text .. value_inner_inner.label:sub(3)
                        else
                            virt_text = virt_text .. value_inner_inner.label
                        end
                    end
                    if i ~= #other_hints then
                        virt_text = virt_text .. ", "
                    end
                end
            end

            if config.options.tools.inlay_hints.right_align then
                virt_text = virt_text .. string.rep(" ", config.options.tools.inlay_hints.right_align_padding)
            end

            if config.options.tools.inlay_hints.max_len_align then
                local max_len = get_max_len(bufnr, parsed)
                virt_text = string.rep(
                    " ",
                    max_len - current_line_len + config.options.tools.inlay_hints.max_len_align_padding
                ) .. virt_text
            end

            -- set the virtual text if it is not empty
            if virt_text ~= "" then
                vim.api.nvim_buf_set_extmark(bufnr, namespace, line, 0, {
                    virt_text_pos = config.options.tools.inlay_hints.right_align and "right_align" or "eol",
                    virt_text = {
                        { virt_text, config.options.tools.inlay_hints.highlight },
                    },
                    hl_mode = "combine",
                })
            end

            -- update state
            enabled = true
        end
    end
end

function M.toggle_inlay_hints()
    if enabled then
        M.disable_inlay_hints()
    else
        M.set_inlay_hints()
    end
    enabled = not enabled
end

function M.disable_inlay_hints()
    -- clear namespace which clears the virtual text as well
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

-- Sends the request to rust-analyzer to get the inlay hints and handle them
function M.set_inlay_hints()
    utils.request(0, "textDocument/inlayHint", get_params(), handler)
end

return M
