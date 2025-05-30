local ok, null = pcall(require, "null-ls")
if not ok then
    return
end

local custom = require "plugins.modules.lsp.custom.null-ls"

local format = null.builtins.formatting
local actions = null.builtins.code_actions
local diag = null.builtins.diagnostics
local completion = null.builtins.completion

null.setup {
    sources = {
        -- format.blackd.with { config = { line_length = 88 } },
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
        format.bibclean,
        -- diag.shellcheck,
        diag.hadolint,
        -- diag.cppcheck,
        format.stylua,
        format.yamlfmt,
        format.clang_format,
        -- format.prettier.with {
        --     extra_args = function(_)
        --         return vim.bo[0].ft == "css" and { "--parser", "css" }
        --     end,
        -- },
        format.cmake_format.with {
            cmd = "cmake-format",
        },
        custom.format["tex-fmt"],
        -- format.latexindent.with {
        --     args = {
        --         "-g",
        --         "/dev/null",
        --         "-y",
        --         [[defaultIndent: "    "]],
        --     },
        -- },
        format.shfmt.with {
            args = { "-s", "-i", "4" },
        },
        format.uncrustify,
        completion.spell,
    },
}
