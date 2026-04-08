vim.pack.add { "https://github.com/stevearc/conform.nvim" }

vim.keymap.set({ "n", "v" }, "<space>f", function()
    require("conform").format {}
end, { desc = "Format buffer" })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format { bufnr = args.buf }
    end,
})

require("conform").setup {
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
