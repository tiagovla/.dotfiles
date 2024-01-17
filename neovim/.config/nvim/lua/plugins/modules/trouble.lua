return {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "<leader>e", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" } },
    config = true,
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match "Trouble" ~= nil then
                    vim.cmd.quit()
                end
            end,
        })
    end,
}
