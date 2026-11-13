vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/olimorris/codecompanion.nvim",
}, { confirm = false })

require("codecompanion").setup {
    adapters = {
        http = {
            omniroute_codex = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    formatted_name = "OmniRoute Codex",
                    env = {
                        url = "OMNIROUTE_HOST",
                        api_key = "OMNIROUTE_API_KEY",
                    },
                    schema = {
                        model = {
                            default = "gpt-6-luna",
                        },
                        reasoning_effort = {
                            mapping = "parameters",
                            type = "string",
                            default = "xhigh",
                        },
                    },
                })
            end,
        },
    },
    interactions = {
        chat = { adapter = "omniroute_codex" },
        inline = { adapter = "omniroute_codex" },
    },
    opts = {
        log_level = "DEBUG", -- or "TRACE"
    },
}
