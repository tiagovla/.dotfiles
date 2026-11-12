---@type vim.lsp.Config
return {
    cmd = {
        "WolframKernel",
        "-noinit",
        "-noprompt",
        "-nopaclet",
        "-noicon",
        "-nostartuppaclets",
        "-run",
        'Needs["LSPServer`"];LSPServer`StartServer[]',
    },
    filetypes = { "wolfram" },
    root_markers = { ".git" },
    settings = {
        wolfram = { implicitTokens = {}, semanticTokens = true },
    },
}
