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
            extra_args = function(_)
                return {
                    "--fast",
                    "--quiet",
                    "--target-version",
                    "py310",
                    "-l",
                    vim.opt_local.colorcolumn:get()[1] or "88",
                }
            end,
        },
        diag.flake8.with {
            extra_args = function(_)
                return { "--max-line-lenth", vim.opt_local.colorcolumn:get()[1] or "88" }
            end,
        },
        completion.spell,
    },
}
