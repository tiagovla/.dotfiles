return {
    "SmiteshP/nvim-navic",
    lazy = false,
    opts = function()
        return {
            separator = " ",
            highlight = true,
            depth_limit = 5,
        }
    end,
    config = function(_, opts)
        vim.g.navic_silence = true
        require("nvim-navic").setup(opts)
    end,
}
