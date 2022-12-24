local map = vim.keymap.set

map("i", "<c-u>", require "luasnip.extras.select_choice")
-- map({ "i", "s" }, "<C-n>", "<Plug>luasnip-next-choice", {})
-- map({ "i", "s" }, "<C-p>", "<Plug>luasnip-prev-choice", {})

local function reload_luasnip_config()
    require("luasnip").cleanup()
    for k in pairs(package.loaded) do
        if k:match ".*luasnip.snips.*" then
            package.loaded[k] = nil
            require(k)
        end
    end
end

map("n", "<space>rs", reload_luasnip_config, { desc = "Reload snippets" })
