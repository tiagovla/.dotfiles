local function config()
    local treesitter = require "nvim-treesitter.configs"
    treesitter.setup {
        ensure_installed = "maintained",
        highlight = { enable = true, additional_vim_regex_highlighting = false, use_languagetree = true },
    }
end

return {
    cmd = { "TSUpdate", "TSInstallSync" },
    run = ":TSUpdate",
    config = config,
}
