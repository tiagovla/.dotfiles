local M = {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    dependencies = {
        {
            "tiagovla/telescope-project.nvim",
            dev = true,
            lazy = false,
        },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "jvgrootveld/telescope-zoxide" },
        { "nvim-telescope/telescope-fzf-native.nvim" },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        },
    },
}

function M.init()
    vim.keymap.set({ "n", "v" }, "<Leader>tc", "<cmd>Telescope commands<cr>", { desc = "Show Commands" })
    vim.keymap.set("n", "<leader>ts", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "FZF current buffer" })
    vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
    vim.keymap.set("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
    vim.keymap.set("n", "<leader>tG", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
    vim.keymap.set("n", "<leader>to", "<cmd>Telescope oldfiles<cr>", { desc = "Old files" })
    vim.keymap.set("n", "<leader>tB", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    vim.keymap.set("n", "<leader>tb", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })
    vim.keymap.set("n", "<leader>th", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
    vim.keymap.set("n", "<leader>tC", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
    vim.keymap.set("n", "<leader>tp", "<cmd>Telescope project<cr>", { desc = "Project" })
    vim.keymap.set("n", "<leader>td", "<cmd>Telescope zoxide list<cr>", { desc = "Zoxide" })
    vim.keymap.set("n", "<leader>tm", "<cmd>Telescope man_pages<cr>", { desc = "Man pages" })
    vim.keymap.set("n", "<leader>tn", "<cmd>Telescope notify<cr>", { desc = "Notifications" })
end

function M.config()
    local custom_theme = {
        pickers = {
            find_files = {
                find_command = { "rg", "--type=file", "--hidden", "--smart-case" },
            },
            live_grep = {
                only_sort_text = true,
            },
        },
        layout_config = {
            prompt_position = "bottom",
            horizontal = {
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        scroll_strategy = "cycle",
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = ">",
        path_display = { "truncate" },
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
            n = {
                ["<c-d>"] = require("telescope.actions").delete_buffer,
            },
        },
    }
    require("telescope").setup {
        defaults = custom_theme,
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    }
    require("telescope").load_extension "project"
    require("telescope").load_extension "zoxide"
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "fzf"
    local builtin = require "telescope.builtin"
    require("telescope._extensions.zoxide.config").setup {
        mappings = {
            ["<CR>"] = {
                keepinsert = true,
                action = function(selection)
                    builtin.find_files { cwd = selection.path }
                end,
                after_action = function(selection)
                    vim.cmd("cd " .. selection.path)
                end,
            },
        },
    }
end

return M
