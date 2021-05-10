local config = {
    cmd = {
        "DiffviewOpen", "DiffviewFocusFiles", "DiffviewToggleFiles", "DiffviewClose",
        "DiffviewRefresh",
    },
    config = function()
        require "plug-config.diffview.settings"
    end,
}

return config
