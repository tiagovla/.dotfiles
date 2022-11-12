local ok, null = pcall(require, "null-ls")
if not ok then
    return
end

local format = null.builtins.formatting
local diag = null.builtins.diagnostics
local actions = null.builtins.code_actions
local completion = null.builtins.completion

null.setup {
    debug = true,
    sources = {
        actions.gitsigns,
        actions.shellcheck,
        diag.shellcheck,
        diag.cppcheck,
        format.stylua,
        format.clang_format,
        format.prettier,
        format.cmake_format.with {
            cmd = "cmake-format",
        },
        format.latexindent.with {
            args = {
                "-g",
                "/dev/null",
                "-y",
                [[defaultIndent: "    "]],
            },
        },
        format.rustfmt,
        format.shfmt.with {
            args = { "-s", "-i", "4" },
        },
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
