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
        format.prettier.with {
            extra_args = function(_)
                return vim.bo[0].ft == "css" and { "--parser", "css" }
            end,
        },
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
                }
            end,
        },
        completion.spell,
    },
}
