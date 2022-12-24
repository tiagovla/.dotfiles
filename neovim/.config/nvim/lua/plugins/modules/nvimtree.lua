local M = {
    "kyazdani42/nvim-tree.lua",
    cmd = {
        "NvimTreeFindFile",
        "NvimTreeFocus",
        "NvimTreeOpen",
        "NvimTreeRefresh",
        "NvimTreeToggle",
    },
}

function M.init()
    local function nvim_tree_smart_toggle()
        local buftype = vim.api.nvim_buf_get_option(0, "filetype")
        vim.cmd "NvimTreeRefresh"
        if buftype ~= "NvimTree" then
            if buftype == "" then
                vim.cmd "NvimTreeFocus"
            else
                vim.cmd "NvimTreeFindFile"
            end
        else
            vim.cmd "NvimTreeToggle"
        end
    end

    vim.keymap.set("n", "<leader>p", nvim_tree_smart_toggle, { desc = "Open tree explorer" })
end

function M.config()
    local tree_cb = require("nvim-tree.config").nvim_tree_callback
    local lib = require "nvim-tree.lib"
    local a = require "plenary.async"

    local nvimtree_keys = {
        { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, cb = tree_cb "edit" },
        { key = { "<BS>", "h" }, u = tree_cb "close_node" },
        {
            key = { "gs" },
            cb = function()
                local node = lib.get_node_at_cursor().absolute_path
                a.run(function()
                    require("neogit.lib.git.cli").add.files(node).call()
                    vim.defer_fn(function()
                        vim.cmd "NvimTreeRefresh"
                    end, 50)
                end)
            end,
        },
        {
            key = { "gu" },
            cb = function()
                local node = lib.get_node_at_cursor().absolute_path
                a.run(function()
                    require("neogit.lib.git.cli").reset.files(node).call()
                    vim.defer_fn(function()
                        vim.cmd "NvimTreeRefresh"
                    end, 50)
                end)
            end,
        },
    }

    require("nvim-tree").setup {
        update_cwd = true,
        disable_netrw = true,
        hijack_netrw = true,
        update_focused_file = {
            enable = false,
        },
        filters = {
            dotfiles = false,
            custom = { ".git", "__pycache__" },
        },
        view = {
            width = 25,
            adaptive_size = false,
            mappings = { list = nvimtree_keys },
        },
        git = {
            enable = true,
            ignore = true,
            timeout = 250,
        },
        trash = {
            cmd = "trash",
            require_confirm = true,
        },
    }

    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "✗",
        },
        folder = {
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
        },
    }
end

return M
