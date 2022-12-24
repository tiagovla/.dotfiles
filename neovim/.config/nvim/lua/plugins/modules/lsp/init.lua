local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        { "williamboman/mason.nvim" },
        { "microsoft/python-type-stubs" },
        { "j-hui/fidget.nvim" },
    },
    event = "BufReadPre",
}
function M.config()
    require "plugins.modules.lsp.custom"
    require "plugins.modules.lsp.settings"
    require "plugins.modules.lsp.mappings"
    require "plugins.modules.lsp.handlers"
    require "plugins.modules.lsp.null-ls"
    require "plugins.modules.lsp.servers"
    require("fidget").setup { window = { blend = 0 } }
end

return M
