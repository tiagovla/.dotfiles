local function config()
    require("tmux").setup {
        copy_sync = {
            enable = true,
        },
        navigation = {
            enable_default_keybindings = true,
        },
        resize = {
            enable_default_keybindings = true,
        },
    }
end

return {
    opt = true,
    setup = function()
        vim.defer_fn(function()
            require("packer").loader "tmux.nvim"
        end, 50)
    end,
    config = config,
}
