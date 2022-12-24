return {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
        vim.g.mkdp_browser = "firefox"
    end,
}
