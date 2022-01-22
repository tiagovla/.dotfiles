local function config()
    require("presence"):setup {
        auto_update = true,
        neovim_image_text = "Neovim",
        main_image = "neovim",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = true,
        blacklist = {},
        buttons = false,
        file_assets = {},
        editing_text = "Editing",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Readings",
        workspace_text = "Working",
        line_number_text = "Line %s out of %s",
    }
end

return {
    config = config,
    commit = "a579a3906ed2cfc980aed6046047ed2ebe4fbd74",
}
