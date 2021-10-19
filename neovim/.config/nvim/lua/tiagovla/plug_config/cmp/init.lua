return {
    config = function()
        require "tiagovla.plug_config.cmp.settings"
    end,
    requires = {
        { "hrsh7th/cmp-buffer", opt = true },
        { "hrsh7th/cmp-nvim-lsp", opt = true },
        { "hrsh7th/cmp-nvim-lua", opt = true },
        { "kdheepak/cmp-latex-symbols", opt = true },
        { "quangnguyen30192/cmp-nvim-ultisnips", opt = true },
        { "hrsh7th/cmp-path", opt = true },
    },
}
