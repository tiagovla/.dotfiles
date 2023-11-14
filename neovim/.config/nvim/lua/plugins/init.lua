local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins.modules", {
    defaults = { lazy = true },
    install = { colorscheme = { "tokyodark" } },
    change_detection = {
        enabled = true,
        notify = false,
    },
    checker = { enabled = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    git = { timeout = 600 },
    debug = false,
    dev = {
        path = "~/github",
        pattern = { "tiagovla" },
        fallback = true,
    },
})
