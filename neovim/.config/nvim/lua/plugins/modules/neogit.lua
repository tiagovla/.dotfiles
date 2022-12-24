local M = { "TimUntersberger/neogit", cmd="Neogit" }

function M.init()
    vim.keymap.set("n", "<space>N", "<cmd>Neogit<CR>", { desc = "Neogit" })
    vim.keymap.set("n", "<space>n", function()
        require("neogit").open { "commit" }
    end, { desc = "Neogit commit" })
end

function M.config()
        require("neogit").setup {
            disable_commit_confirmation = true,
            auto_refresh = true,
            integrations = {
                diffview = true,
            },
        }
end

return M
