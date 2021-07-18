-- require('telescope').load_extension('media_files')
require("telescope").setup {
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case"
        },
        prompt_prefix = ">",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {mirror = false},
            vertical = {mirror = false},
            prompt_position = "bottom",
            preview_cutoff = 120,
            width = 0.75
        },
        file_sorter = require"telescope.sorters".get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require"telescope.sorters".get_generic_fuzzy_sorter,
        -- shorten_path = true,
        winblend = 0,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        use_less = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
        file_previewer = require"telescope.previewers".vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
        grep_previewer = require"telescope.previewers".vim_buffer_vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
        qflist_previewer = require"telescope.previewers".vim_buffer_qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require"telescope.previewers".buffer_previewer_maker

    }
    -- extensions = {
    -- media_files = {
    -- filetypes = {"png", "webp", "jpg", "jpeg"},
    -- find_cmd = "rg"
    -- }
    -- }
}
