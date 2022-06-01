return {
    config = function()
        require "plugins.config.luasnip.mappings"

        require("luasnip").cleanup()
        require "plugins.config.luasnip.settings"

        require "plugins.config.luasnip.snips.lua"
        require "plugins.config.luasnip.snips.python"
        require "plugins.config.luasnip.snips.tex"
        require "plugins.config.luasnip.snips.tex_math"
    end,
}
