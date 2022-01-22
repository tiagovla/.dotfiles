return {
    config = function()
        require("null-ls").setup {
            sources = {
                require("null-ls").builtins.diagnostics.flake8,
                require("null-ls").builtins.diagnostics.pylint,
            },
        }
    end,
}
