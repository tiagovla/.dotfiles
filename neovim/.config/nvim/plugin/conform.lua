vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

require("conform").setup {
    format_on_save = function(bufnr)
        if vim.g.format_on_save then
            vim.api.nvim_buf_call(bufnr, function()
                local luasnip = require "luasnip"
                if luasnip.in_snippet() then
                    luasnip.unlink_current()
                end
            end)
            return { timeout_ms = 3000, lsp_format = "fallback" }
        end
    end,
    formatters_by_ft = {
        python = { "black" },
        bib = { "bibclean" },
        lua = { "stylua" },
        yaml = { "yamlfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier_css" },
        json = { "prettier" },
        cmake = { "cmake_format" },
        -- tex = { "tex_fmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
    },
    formatters = {
        black = {
            prepend_args = { "--fast", "--quiet" },
        },
        prettier_css = {
            inherit = "prettier",
            prepend_args = { "--parser", "css" },
        },
        cmake_format = {
            command = "cmake-format",
        },
        shfmt = {
            prepend_args = { "-s", "-i", "4" },
        },
        tex_fmt = {
            command = "tex-fmt",
        },
    },
}

vim.keymap.set({ "n", "v" }, "<space>f", function()
    require("conform").format {}
end, { desc = "Format buffer" })
