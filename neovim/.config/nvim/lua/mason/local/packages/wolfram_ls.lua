local configs = require "lspconfig.configs"
local util = require "lspconfig.util"

if not configs["wolfram_ls"] then
    configs["wolfram_ls"] = {
        default_config = {
            filetypes = { "wolfram" },
            root_dir = util.find_git_ancestor,
            cmd = {
                "WolframKernel",
                "-noinit",
                "-noprompt",
                "-nopaclet",
                "-noicon",
                "-nostartuppaclets",
                "-run",
                [[ Needs["LSPServer`"];LSPServer`StartServer[] ]],
            },
            single_file_support = true,
            settings = {
                wolfram = { implicitTokens = {}, semanticTokens = true },
            },
        },
    }
end
