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
        -- format.blackd.with { config = {line_length = 88 } },
        -- diag.textidote.with {
        --     args = {
        --         "--read-all",
        --         "--output",
        --         "singleline",
        --         "--no-color",
        --         "$FILENAME",
        --     },
        --     timeout = 20000,
        -- },
        format.black.with {
            extra_args = function(_)
                return {
                    "--fast",
                    "--quiet",
                }
            end,
        },
        actions.gitsigns,
        actions.shellcheck,
        format.bibclean,
        diag.shellcheck,
        -- diag.cppcheck,
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
        completion.spell,
    },
}
