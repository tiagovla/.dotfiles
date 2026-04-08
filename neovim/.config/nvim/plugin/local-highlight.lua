vim.pack.add { "https://github.com/tzachar/local-highlight.nvim" }

require("local-highlight").setup {
    file_types = { "python", "cpp", "lua" },
    hlgroup = "Visual",
    animate = false,
}
