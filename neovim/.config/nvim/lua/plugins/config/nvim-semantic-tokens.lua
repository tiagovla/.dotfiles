local function config()
    require("nvim-semantic-tokens").setup {
        preset = "default",
        highlighters = { require "nvim-semantic-tokens.table-highlighter" },
    }
end

return {
    config = config,
}
