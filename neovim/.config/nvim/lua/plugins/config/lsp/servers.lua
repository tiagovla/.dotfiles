local lsp_installer = require "nvim-lsp-installer"
local utils = require "plugins.config.lsp.utils"

local configs = {}
local mt = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

function mt:__index(k)
    local ok, res = pcall(require, "plugins.config.lsp.servers." .. k)

    if k == "efm" then
        require "plugins.config.lsp.servers.efm"
    end
    if ok then
        self[k] = res
        return res
    end
    return { on_attach = utils.common.on_attach, capabilities = capabilities }
end
configs = setmetatable(configs, mt)

local exclude = { "ltex", "black-formatter" }

lsp_installer.on_server_ready(function(server)
    if vim.tbl_contains(exclude, server.name) then
        return
    end
    local opts = configs[server.name]
    server:setup(opts)
end)
