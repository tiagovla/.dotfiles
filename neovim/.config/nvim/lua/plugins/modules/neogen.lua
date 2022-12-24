local M = { "danymat/neogen", cmd="Neogen", dependencies = "nvim-treesitter/nvim-treesitter" }

function M.setup()
    vim.keymap.set("n", "<leader>gd", "<cmd>Neogen<cr>", { desc = "Neogen" })
end
function M.config()
    require("neogen").setup {
        enabled = true,
    }
end

return M
