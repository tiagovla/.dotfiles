return {
    "neogitorg/neogit",
    keys = {
        {
            "<space>N",
            function()
                require("neogit").open()
            end,
            desc = "Neogit",
        },
        {
            "<space>n",
            function()
                require("neogit").open { "commit" }
            end,
            desc = "Neogit commit",
        },
    },
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
        disable_commit_confirmation = true,
        integrations = {
            diffview = true,
        },
    },
}
