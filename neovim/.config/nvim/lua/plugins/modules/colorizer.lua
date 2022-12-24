local M = { "norcalli/nvim-colorizer.lua", ft = { "html", "css", "sass", "vim", "lua", "javascript", "typescript" } }

function M.config()
    require("colorizer").setup({ "*" }, {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
    })
end

return M
