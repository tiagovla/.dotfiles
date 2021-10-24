require "plugins.config.vimdoge.mappings"

return {
    cmd = "DogeGenerate",
    config = function()
        require "plugins.config.vimdoge.settings"
    end,
}
