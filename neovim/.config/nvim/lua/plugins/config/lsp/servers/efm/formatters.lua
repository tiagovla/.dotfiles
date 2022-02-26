local F = {}

F.rustfmt = {
    formatCommand = "rustfmt",
    formatStdin = true,
    lintCommand = "cargo clippy",
    lintSource = "cargo",
    lintFormats = { "%f:%l:%c: %m" },
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
F.flake8 = {
    prefix = "flake8",
    lintCommand = "flake8 --ignore=E203,F401,F841,W503 --max-line-length 88 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintFormats = { "%.%#:%l:%c: %t%n %m" },
    rootMarkers = { "setup.cfg", "tox.ini", ".flake8" },
}

return F
