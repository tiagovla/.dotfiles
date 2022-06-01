local L = {}

L.flake8 = {
    prefix = "flake8",
    lintCommand = "flake8 --ignore=E203,F401,F841,W503 --max-complexity 39 --max-line-length 120 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintFormats = { "%.%#:%l:%c: %t%n %m" },
    rootMarkers = { "setup.cfg", "tox.ini", ".flake8" },
}

L.shellcheck = {
    LintCommand = "shellcheck -f gcc -x",
    lintFormats = {
        "%f:%l:%c: %trror: %m",
        "%f:%l:%c: %tarning: %m",
        "%f:%l:%c: %tote: %m",
    },
}

return L
