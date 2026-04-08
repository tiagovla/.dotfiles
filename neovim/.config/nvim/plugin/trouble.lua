vim.pack.add {
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/folke/trouble.nvim",
}

vim.keymap.set("n", "<leader>e", function()
    local api = require "trouble.api"
    if api.is_open() then
        api.close()
    else
        vim.cmd.Trouble "diagnostics"
    end
end, { desc = "Toggle Trouble" })

require("trouble").setup {
    keys = {
        ["<c-p>"] = "prev",
        ["<c-n>"] = "next",
    },
}

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match "Trouble" ~= nil then
            vim.cmd.quit()
        end
    end,
})
