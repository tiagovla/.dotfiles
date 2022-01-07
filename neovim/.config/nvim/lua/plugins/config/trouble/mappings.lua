local keymap = vim.keymap

keymap.set("n", "]t", function()
    require("trouble").next { skip_groups = true, jump = true }
end)

keymap.set("n", "[t", function()
    require("trouble").previous { skip_groups = true, jump = true }
end)

keymap.set("n", "<space>q", function()
    require("trouble").toggle { focus = false }
end)
