local ok, null = pcall(require, "null-ls")
if not ok then
    return
end

local format = null.builtins.formatting
local diag = null.builtins.diagnostics
local actions = null.builtins.code_actions
local completion = null.builtins.completion

null.setup {
    sources = {
        actions.gitsigns,
        actions.shellcheck,
        diag.shellcheck,
        format.stylua,
        format.black.with {
            extra_args = {
                "--fast",
                "--quiet",
                "--target-version",
                "py310",
            },
        },
        diag.flake8.with {
            extra_args = { "--max-line-lenth", "88" },
        },
        completion.spell,
    },
}
