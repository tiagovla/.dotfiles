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
    local function smart_toggle()
        local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
        if ft == "NvimTree" then
            vim.cmd.NvimTreeToggle()
        elseif ft == "" then
            vim.cmd.NvimTreeFocus()
        else
            vim.cmd.NvimTreeFindFile()
        end
    end

    vim.keymap.set("n", "<leader>p", smart_toggle, { desc = "Open tree explorer" })

    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            if vim.api.nvim_buf_get_name(0):match "NvimTree" ~= nil then
                if vim.api.nvim_win_get_width(0) == vim.o.columns then
                    vim.cmd.quit()
                end
            end
        end,
    })
end

local function on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function map(key, fn, desc)
        vim.keymap.set("n", key, fn, {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
        })
    end

    -- Basic navigation and opening
    map("<CR>", api.node.open.edit, "Open")
    map("o", api.node.open.edit, "Open")
    -- map("l", api.node.open.edit, "Open")
    map("<2-LeftMouse>", api.node.open.edit, "Open")

    -- Directory navigation
    map("<C-]>", api.tree.change_root_to_node, "CD")
    map("-", api.tree.change_root_to_parent, "Up")
    map("<BS>", api.node.navigate.parent_close, "Close Directory")
    map("P", api.node.navigate.parent, "Parent Directory")

    -- Open in split/tab
    map("<C-e>", api.node.open.replace_tree_buffer, "Open: In Place")
    map("<C-t>", api.node.open.tab, "Open: New Tab")
    map("<C-v>", api.node.open.vertical, "Open: Vertical Split")
    map("<C-x>", api.node.open.horizontal, "Open: Horizontal Split")
    map("O", api.node.open.no_window_picker, "Open: No Window Picker")

    -- File operations
    map("a", api.fs.create, "Create")
    map("d", api.fs.remove, "Delete")
    map("D", api.fs.trash, "Trash")
    map("r", api.fs.rename, "Rename")
    map("e", api.fs.rename_basename, "Rename: Basename")
    map("<C-r>", api.fs.rename_sub, "Rename: Omit Filename")
    map("c", api.fs.copy.node, "Copy")
    map("x", api.fs.cut, "Cut")
    map("p", api.fs.paste, "Paste")

    -- Filters and toggles
    map("H", api.tree.toggle_hidden_filter, "Toggle Dotfiles")
    map("I", api.tree.toggle_gitignore_filter, "Toggle Git Ignore")
    map("B", api.tree.toggle_no_buffer_filter, "Toggle No Buffer")
    map("C", api.tree.toggle_git_clean_filter, "Toggle Git Clean")
    map("U", api.tree.toggle_custom_filter, "Toggle Hidden")

    -- Git
    map("]c", api.node.navigate.git.next, "Next Git")
    map("[c", api.node.navigate.git.prev, "Prev Git")

    -- Diagnostics
    map("]e", api.node.navigate.diagnostics.next, "Next Diagnostic")
    map("[e", api.node.navigate.diagnostics.prev, "Prev Diagnostic")

    -- Bookmarks and marks
    map("m", api.marks.toggle, "Toggle Bookmark")
    map("bmv", api.marks.bulk.move, "Move Bookmarked")

    -- Search and filter
    map("f", api.live_filter.start, "Filter")
    map("F", api.live_filter.clear, "Clean Filter")
    map("S", api.tree.search_node, "Search")

    -- Misc
    map("g?", api.tree.toggle_help, "Help")
    map("s", api.node.run.system, "Run System")
    map(".", api.node.run.cmd, "Run Command")
    map("q", api.tree.close, "Close")
    map("R", api.tree.reload, "Refresh")
    map("E", api.tree.expand_all, "Expand All")
    map("W", api.tree.collapse_all, "Collapse")
    map("gy", api.fs.copy.absolute_path, "Copy Absolute Path")
    map("y", api.fs.copy.filename, "Copy Name")
    map("Y", api.fs.copy.relative_path, "Copy Relative Path")
    map(">", api.node.navigate.sibling.next, "Next Sibling")
    map("<", api.node.navigate.sibling.prev, "Previous Sibling")
    map("J", api.node.navigate.sibling.last, "Last Sibling")
    map("K", api.node.navigate.sibling.first, "First Sibling")
    map("<leader>hs", function()
        local api = require "nvim-tree.api"
        local node = api.tree.get_node_under_cursor()
        if not node or not node.absolute_path then
            return
        end

        vim.system({ "git", "add", node.absolute_path }, {}, function()
            vim.schedule(api.tree.reload)
        end)
    end, "Git Stage File")
    map("<leader>hr", function()
        local api = require "nvim-tree.api"
        local node = api.tree.get_node_under_cursor()
        if not node or not node.absolute_path then
            return
        end

        vim.system({ "git", "restore", "--staged", node.absolute_path }, {}, function()
            vim.schedule(api.tree.reload)
        end)
    end, "Git Unstage File")
end

function M.config()
    require("nvim-tree").setup {
        on_attach = on_attach,
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
