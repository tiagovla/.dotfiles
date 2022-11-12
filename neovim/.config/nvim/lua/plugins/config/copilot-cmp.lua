local function config()
    require("copilot_cmp").setup {
        force_autofmt = true,
    }
end
return {
    config = config,
}
