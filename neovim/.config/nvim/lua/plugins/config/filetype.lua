local function config()
    require("filetype").setup {
        overrides = {
            extensions = {
                pn = "potion",
            },
            literal = {
                MyBackupFile = "lua",
            },
            complex = {
                [".*git/config"] = "gitconfig", -- Included in the plugin
            },

            function_extensions = {
                ["cpp"] = function()
                    vim.bo.filetype = "cpp"
                    vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
                end,
                ["pdf"] = function()
                    vim.bo.filetype = "pdf"
                    vim.fn.jobstart("open -a skim " .. '"' .. vim.fn.expand "%" .. '"')
                end,
            },
            function_literal = {
                Brewfile = function()
                    vim.cmd "syntax off"
                end,
            },
            function_complex = {
                ["*.math_notes/%w+"] = function()
                    vim.cmd "iabbrev $ $$"
                end,
            },

            shebang = {
                dash = "sh",
            },
        },
    }
end

return {
    config = config,
}
