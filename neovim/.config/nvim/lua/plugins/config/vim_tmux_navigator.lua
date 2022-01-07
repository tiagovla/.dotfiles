return {
    opt = true,
    setup = function()
        vim.defer_fn(function()
            require("packer").loader "vim-tmux-navigator"
        end, 50)
    end,
    config = function() end,
}
