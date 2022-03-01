local F = {}

F.rustfmt = {
    formatCommand = "rustfmt",
    formatStdin = true,
    lintCommand = "cargo clippy",
    lintSource = "cargo",
    lintFormats = { "%f:%l:%c: %m" },
}
F.isort = {
    formatCommand = "isort --quiet -",
    formatStdin = true,
}
F.black = {
    formatCommand = "black --quiet -",
    formatStdin = true,
}
F.stylua = {
    formatCommand = "stylua -s -",
    formatStdin = true,
}
F.clang_format = { formatCommand = "clang-format", formatStdin = true }
F.cmake_format = { formatCommand = "cmake-format", formatStdin = true }
F.isort = { formatCommand = "isort --quiet -", formatStdin = true }
F.latexindent = { formatCommand = [[latexindent -y="defaultIndent: '    '"]], formatStdin = true }
F.lua_format = { formatCommand = "lua-format", formatStdin = true }
F.prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT}",
    formatStdin = true,
}
return F
