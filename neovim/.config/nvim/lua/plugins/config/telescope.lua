local keymap = vim.keymap

local function mappings()
    keymap.set({ "n", "v" }, "<Leader>tc", "<cmd>Telescope commands<cr>", { desc = "Show Commands" })
    keymap.set("n", "<leader>ts", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "FZF current buffer" })
    keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
    keymap.set("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
    keymap.set("n", "<leader>tb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    keymap.set("n", "<leader>th", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
    keymap.set("n", "<leader>tC", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
    keymap.set("n", "<leader>tp", "<cmd>Telescope project<cr>", { desc = "Project" })
    keymap.set("n", "<Leader>td", "<cmd>Telescope zoxide list<cr>", { desc = "Zoxide" })
    keymap.set("n", "<Leader>cd", "<cmd>Telescope zoxide list<cr>", { desc = "Zoxide" })
    keymap.set("n", "<Leader>tm", "<cmd>Telescope man_pages<cr>", { desc = "Man pages" })
    keymap.set("n", "<Leader>tn", "<cmd>Telescope notify<cr>", { desc = "Notifications" })
end

local function config()
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
    }
    require("telescope").setup {
        -- defaults = require("telescope.themes").get_ivy {},
        defaults = custom_theme,
    }
end

mappings()
return {
    cmd = { "Telescope", "SearchSession" },
    config = config,
    requires = { "nvim-treesitter/nvim-treesitter" },
}
