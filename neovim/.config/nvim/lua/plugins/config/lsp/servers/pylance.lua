local path = require("lspconfig/util").path
local utils = require "plugins.config.lsp.utils"

local function get_python_path(workspace)
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

local configs = {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                completeFunctionParens = true,
                indexing = false,
            },
        },
    },
    before_init = function(_, config)
        local stub_path = require("lspconfig/util").path.join(
            vim.fn.stdpath "data",
            "site",
            "pack",
            "packer",
            "opt",
            "python-type-stubs"
        )
        config.settings.python.analysis.stubPath = stub_path
    end,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
    end,
}

return configs
