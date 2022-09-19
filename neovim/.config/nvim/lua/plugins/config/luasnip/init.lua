return {
    config = function()
        require "plugins.config.luasnip.mappings"
        require "plugins.config.luasnip.settings"
        require "plugins.config.luasnip.snips.lua"
        require "plugins.config.luasnip.snips.cmake"
        require "plugins.config.luasnip.snips.python"
        require "plugins.config.luasnip.snips.tex"
        require "plugins.config.luasnip.snips.tex_math"
        require "plugins.config.luasnip.snips.cpp"
    end,
}
