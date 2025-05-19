return {
    "ThePrimeagen/harpoon",
    lazy = false,
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local opts = { noremap = true, silent = true }
        local harpoon = require "harpoon"
        harpoon:setup()
        vim.keymap.set("n", "<leader><Tab>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, opts)

        for i = 1, 9 do
            vim.keymap.set("n", "<leader>" .. i, function()
                harpoon:list():select(i)
            end, { desc = "Harpoon " .. i .. " file" })
        end
        vim.keymap.set("n", "<s-m>", function()
            harpoon:list():add()
            vim.notify "marked file"
        end, opts)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "harpoon",
            callback = function()
                for i = 1, 9 do
                    vim.keymap.set("n", tostring(i), function()
                        harpoon:list():select(i)
                    end, { buffer = true })
                end
            end,
        })
    end,
}
