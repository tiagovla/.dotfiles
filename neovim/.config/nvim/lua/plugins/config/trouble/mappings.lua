local keymap = vim.keymap

keymap.set("n", "]t", function()
    require("trouble").next { skip_groups = true, jump = true }
end, { desc = "Next trouble" })

keymap.set("n", "[t", function()
    require("trouble").previous { skip_groups = true, jump = true }
end, { desc = "Previous trouble" })

keymap.set("n", "<space>tt", function()
    require("trouble").toggle { focus = false }
end, { desc = "Trouble" })
