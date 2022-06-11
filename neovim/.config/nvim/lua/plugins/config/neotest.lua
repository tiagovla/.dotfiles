local function config()
    require("neotest").setup {
        adapters = {
            require "neotest-python" { },
        },
    }
end

return {
    config = config,
}
