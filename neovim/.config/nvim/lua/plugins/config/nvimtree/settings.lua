local tree_cb = require("nvim-tree.config").nvim_tree_callback

local nvimtree_keys = {
    { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, cb = tree_cb "edit" },
    { key = { "<BS>", "h" }, cb = tree_cb "close_node" },
}

require("nvim-tree").setup {
    update_cwd = false,
    disable_netrw = true,
    hijack_netrw = true,
    auto_close = false,
    tree_follow = 1,
    update_focused_file = {
        enable = false,
    },
    filters = {
        dotfiles = false,
        custom = { ".git", "__pycache__" },
    },
    view = {
        width = 30,
        auto_resize = true,
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
