-- pcall(require, "plug-config.cmp.mappings")
local config = {
    -- event = "InsertEnter",
    config = function() require("plug-config.cmp.settings") end,
    requires = {
        {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/cmp-nvim-lua"}, {"kdheepak/cmp-latex-symbols"},
        {"quangnguyen30192/cmp-nvim-ultisnips"}, {"hrsh7th/cmp-path"}
    }
}

return config
