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
        require("nvim-tree.actions.reloaders.reloaders").reload_explorer()
        if buftype ~= "NvimTree" then
            if buftype == "" then
                require("nvim-tree").focus()
            else
                vim.cmd [[NvimTreeFindFile]]
            end
        else
            require("nvim-tree").toggle(true, false)
        end
    end

    vim.keymap.set("n", "<leader>p", nvim_tree_smart_toggle, { desc = "Open tree explorer" })
end

function M.config()
    local tree_cb = require("nvim-tree.config").nvim_tree_callback

    local nvimtree_keys = {
        { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, cb = tree_cb "edit" },
        { key = { "<BS>", "h" }, u = tree_cb "close_node" },
    }

    local function git_extend_key(keys)
        local lib = require "nvim-tree.lib"
        local a = require "plenary.async"
        local cli = require "neogit.lib.git.cli"
        local function wrap(action)
            return function()
                local node = lib.get_node_at_cursor().absolute_path
                a.run(function()
                    cli[action].files(node).call()
                    vim.defer_fn(function()
                        require("nvim-tree.actions.reloaders.reloaders").reload_explorer()
                    end, 50)
                end)
            end
        end
        keys[#keys + 1] = {
            key = { "gs" },
            cb = wrap "add",
        }
        keys[#keys + 1] = {
            key = { "gu" },
            cb = wrap "reset",
        }
    end

    pcall(git_extend_key, nvimtree_keys)

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
end

return M
