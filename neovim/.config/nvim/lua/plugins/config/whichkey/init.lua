return {
    opt = true,
    setup = function()
        vim.defer_fn(function()
            require("packer").loader "which-key.nvim"
        end, 200)
    end,
    config = function()
        require "plugins.config.whichkey.mappings"
        require "plugins.config.whichkey.settings"
    end,
}
