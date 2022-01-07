return {
    ft = { "html", "css", "sass", "vim", "lua", "javascript", "typescript" },
    config = function()
        require("colorizer").setup({ "*" }, {
            RGB = true,
            RRGGBB = true,
            RRGGBBAA = true,
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
        })
    end,
}
