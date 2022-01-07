local keymap = vim.keymap

local function mappings()
    keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<cr>")
    keymap.set("n", "<leader>tg", "<cmd>Telescope live_grep<cr>")
    keymap.set("n", "<leader>tb", "<cmd>Telescope buffers<cr>")
    keymap.set("n", "<leader>th", "<cmd>Telescope help_tags<cr>")
    keymap.set("n", "<leader>tc", "<cmd>Telescope colorscheme<cr>")
    keymap.set("n", "<leader>tp", "<cmd>Telescope project<cr>")
end

local function config()
    require("telescope").setup {
        defaults = {
            pickers = {
                find_files = {
                    find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
                },
                live_grep = {
                    only_sort_text = true,
                },
            },
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
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = { mirror = false },
                vertical = { mirror = false },
                prompt_position = "bottom",
                preview_cutoff = 120,
                width = 0.75,
            },
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
        },
    }
end

mappings()
return {
    cmd = { "Telescope", "SearchSession" },
    config = config,
}
