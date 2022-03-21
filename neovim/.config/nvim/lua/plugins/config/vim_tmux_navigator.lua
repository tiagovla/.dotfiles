return {
    opt = true,
    setup = function()
        vim.api.nvim_create_autocmd("VimLeave", { command = "silent !tmux set status on" })
        vim.defer_fn(function()
            require("packer").loader "vim-tmux-navigator"
        end, 50)
    end,
    config = function() end,
}
