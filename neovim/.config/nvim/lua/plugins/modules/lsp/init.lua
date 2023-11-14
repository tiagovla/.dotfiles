local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "nvimtools/none-ls.nvim" },
        { "williamboman/mason.nvim" },
        { "microsoft/python-type-stubs" },
        { "barreiroleo/ltex_extra.nvim" },
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
}
function M.config()
    require "plugins.modules.lsp.custom"
    require "plugins.modules.lsp.settings"
    require "plugins.modules.lsp.mappings"
    require "plugins.modules.lsp.handlers"
    require "plugins.modules.lsp.null-ls"
    require "plugins.modules.lsp.servers"
end

return M
