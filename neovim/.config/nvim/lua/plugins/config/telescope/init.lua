require "plugins.config.telescope.mappings"

return {
    cmd = { "Telescope", "SearchSession" },
    config = function()
        require "plugins.config.telescope.settings"
    end,
}
