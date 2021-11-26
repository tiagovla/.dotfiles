local util = require "lspconfig/util"
local path = util.path

M = {}

function M.define_signs(signs)
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

function M.get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    -- Find and use virtualenv via poetry in workspace directory.
    local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
    if match ~= "" then
        local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
        return path.join(venv, "bin", "python")
    end

    -- Fallback to system Python.
    return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local configs = require "lspconfig/configs"
local lsp = vim.lsp

local texlab_build_status = vim.tbl_add_reverse_lookup {
    Success = 0,
    Error = 1,
    Failure = 2,
    Cancelled = 3,
}

local texlab_forward_status = vim.tbl_add_reverse_lookup {
    Success = 0,
    Error = 1,
    Failure = 2,
    Unconfigured = 3,
}

function M.texlab_buf_build(bufnr)
    local texlab_client = nil
    for _, v in ipairs(vim.lsp.buf_get_clients(0)) do
        if v.name == "texlab" then
            texlab_client = v
        end
    end
    if texlab_client then
        bufnr = util.validate_bufnr(bufnr)
        local params = {
            textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        }
        texlab_client.request(
            "textDocument/build",
            params,
            util.compat_handler(function(err, result)
                if err then
                    error(tostring(err))
                end
                print("Build " .. texlab_build_status[result.status])
            end),
            bufnr
        )
    end
end

function M.texlab_buf_search(bufnr)
    local texlab_client = nil
    for _, v in ipairs(vim.lsp.buf_get_clients(0)) do
        if v.name == "texlab" then
            texlab_client = v
        end
    end
    if texlab_client then
        bufnr = util.validate_bufnr(bufnr)
        local params = {
            textDocument = { uri = vim.uri_from_bufnr(bufnr) },
            position = { line = vim.fn.line "." - 1, character = vim.fn.col "." },
        }
        texlab_client.request(
            "textDocument/forwardSearch",
            params,
            util.compat_handler(function(err, result)
                if err then
                    error(tostring(err))
                end
                print("Search " .. texlab_forward_status[result.status])
            end),
            bufnr
        )
    end
end

return M
