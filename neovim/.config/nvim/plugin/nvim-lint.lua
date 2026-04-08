vim.pack.add { "https://github.com/mfussenegger/nvim-lint" }

local lint = require "lint"
lint.linters_by_ft = {
    ["cpp"] = { "cppcheck" },
    ["hpp"] = { "cppcheck" },
}
lint.linters.cppcheck.args[#lint.linters.cppcheck.args + 1] = "--check-level=exhaustive"
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
