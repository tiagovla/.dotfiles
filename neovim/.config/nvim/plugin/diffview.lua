vim.pack.add(
    { "https://github.com/dlyongemallo/diffview-plus.nvim", "https://github.com/akinsho/git-conflict.nvim" },
    { confirm = false }
)

vim.keymap.set("n", "<leader>D", ":DiffviewToggle<cr>", { silent = true })
vim.keymap.set("n", "<leader>dh", ":DiffviewToggleHistory<cr>", { silent = true })
vim.keymap.set("n", "<leader>df", ":DiffviewToggleFiles<cr>", { silent = true })

require("git-conflict").setup()

local actions = require "diffview.actions"

vim.api.nvim_create_user_command("DiffviewToggle", function(e)
    local view = require("diffview.lib").get_current_view()
    if view then
        vim.cmd "DiffviewClose"
    else
        vim.cmd("DiffviewOpen " .. e.args)
    end
end, { nargs = "*" })

vim.api.nvim_create_user_command("DiffviewToggleHistory", function(e)
    local view = require("diffview.lib").get_current_view()
    if view then
        vim.cmd "DiffviewClose"
    else
        vim.cmd("DiffviewFileHistory " .. e.args)
    end
end, { nargs = "*" })

require("diffview").setup {
    diff_binaries = false,
    enhanced_diff_hl = false,
    git_cmd = { "git" },
    use_icons = true,
    icons = {
        folder_closed = "",
        folder_open = "",
    },
    signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
    },
    view = {
        default = {
            layout = "diff2_horizontal",
        },
        merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
        },
        file_history = {

            layout = "diff2_horizontal",
        },
    },
    file_panel = {
        listing_style = "tree",
        tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
        },
        win_config = {
            position = "left",
            width = 35,
        },
    },
    file_history_panel = {
        -- log_options = {
        --     single_file = {
        --         diff_merges = "combined",
        --     },
        --     multi_file = {
        --         diff_merges = "first-parent",
        --     },
        -- },
        win_config = {
            position = "bottom",
            height = 16,
        },
    },
    commit_log_panel = {
        win_config = {},
    },
    default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
    },
    hooks = {},
    keymaps = {
        disable_defaults = true,
        view = {
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
            ["gf"] = actions.goto_file,
            ["<C-w><C-f>"] = actions.goto_file_split,
            ["<C-w>gf"] = actions.goto_file_tab,
            ["<leader>e"] = actions.focus_files,
            ["<leader>b"] = actions.toggle_files,
            ["g<C-x>"] = actions.cycle_layout,
            ["[x"] = actions.prev_conflict,
            ["]x"] = actions.next_conflict,
            ["<leader>co"] = actions.conflict_choose "ours",
            ["<leader>ct"] = actions.conflict_choose "theirs",
            ["<leader>cb"] = actions.conflict_choose "base",
            ["<leader>ca"] = actions.conflict_choose "all",
            ["dx"] = actions.conflict_choose "none",
        },
        diff1 = {},
        diff2 = {},
        diff3 = {

            { { "n", "x" }, "2do", actions.diffget "ours" },
            { { "n", "x" }, "3do", actions.diffget "theirs" },
        },
        diff4 = {

            { { "n", "x" }, "1do", actions.diffget "base" },
            { { "n", "x" }, "2do", actions.diffget "ours" },
            { { "n", "x" }, "3do", actions.diffget "theirs" },
        },
        file_panel = {
            ["j"] = actions.next_entry,
            ["<down>"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["o"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["-"] = actions.toggle_stage_entry,
            ["S"] = actions.stage_all,
            ["U"] = actions.unstage_all,
            ["X"] = actions.restore_entry,
            ["R"] = actions.refresh_files,
            ["l"] = actions.open_commit_log,
            ["L"] = nil,
            ["<c-b>"] = actions.scroll_view(-0.25),
            ["<c-f>"] = actions.scroll_view(0.25),
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
            ["gf"] = actions.goto_file,
            ["<C-w><C-f>"] = actions.goto_file_split,
            ["<C-w>gf"] = actions.goto_file_tab,
            ["i"] = actions.listing_style,
            ["f"] = actions.toggle_flatten_dirs,
            ["<leader>e"] = actions.focus_files,
            ["<leader>b"] = actions.toggle_files,
            ["g<C-x>"] = actions.cycle_layout,
            ["[x"] = actions.prev_conflict,
            ["]x"] = actions.next_conflict,
        },
        file_history_panel = {
            ["g!"] = actions.options,
            ["<C-A-d>"] = actions.open_in_diffview,
            ["y"] = actions.copy_hash,
            ["L"] = actions.open_commit_log,
            ["zR"] = actions.open_all_folds,
            ["zM"] = actions.close_all_folds,
            ["j"] = actions.next_entry,
            ["<down>"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["o"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<c-b>"] = actions.scroll_view(-0.25),
            ["<c-f>"] = actions.scroll_view(0.25),
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
            ["gf"] = actions.goto_file,
            ["<C-w><C-f>"] = actions.goto_file_split,
            ["<C-w>gf"] = actions.goto_file_tab,
            ["<leader>e"] = actions.focus_files,
            ["<leader>b"] = actions.toggle_files,
            ["g<C-x>"] = actions.cycle_layout,
        },
        option_panel = {
            ["<tab>"] = actions.select_entry,
            ["q"] = actions.close,
        },
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "DiffviewFiles",
    callback = function(event)
        require("which-key").add {
            buffer = event.buf,
            { "<leader>D", desc = "Toggle Diffview" },
            { "<leader>d", group = "Diffview" },
            { "<leader>dh", desc = "Toggle file history" },
            { "<leader>df", desc = "Toggle files" },
            { "<leader>b", desc = "Toggle file panel" },
            { "<leader>e", desc = "Focus file panel" },
            { "j", desc = "Next entry" },
            { "<down>", desc = "Next entry" },
            { "k", desc = "Previous entry" },
            { "<up>", desc = "Previous entry" },
            { "<cr>", desc = "Open selected entry" },
            { "o", desc = "Open selected entry" },
            { "-", desc = "Stage or unstage entry" },
            { "S", desc = "Stage all entries" },
            { "U", desc = "Unstage all entries" },
            { "X", desc = "Restore entry" },
            { "R", desc = "Refresh file list" },
            { "l", desc = "Open commit log" },
            { "<c-b>", desc = "Scroll view up" },
            { "<c-f>", desc = "Scroll view down" },
            { "<tab>", desc = "Select next entry" },
            { "<s-tab>", desc = "Select previous entry" },
            { "gf", desc = "Open file" },
            { "<C-w><C-f>", desc = "Open file in split" },
            { "<C-w>gf", desc = "Open file in new tab" },
            { "i", desc = "Toggle listing style" },
            { "f", desc = "Toggle directory flattening" },
            { "g<C-x>", desc = "Cycle diff layout" },
            { "[x", desc = "Previous conflict" },
            { "]x", desc = "Next conflict" },
        }
    end,
})

local diffview = require "diffview"
local diffview_lib = require "diffview.lib"

vim.api.nvim_create_autocmd("WinClosed", {
    pattern = "*",
    callback = function(event)
        local winid = tonumber(event.file)
        if not winid then
            return
        end

        vim.schedule(function()
            for _, view in ipairs(diffview_lib.views) do
                local owns_window = false

                for _, win in ipairs(view.cur_layout and view.cur_layout.windows or {}) do
                    if win.id == winid then
                        owns_window = true
                        break
                    end
                end

                if owns_window and not view.closing:check() then
                    diffview.close(view.tabpage, { force = false })
                    return
                end
            end
        end)
    end,
})
