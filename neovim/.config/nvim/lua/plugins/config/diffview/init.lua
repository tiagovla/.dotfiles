return {
    cmd = {
        "DiffviewOpen",
        "DiffviewFocusFiles",
        "DiffviewToggleFiles",
        "DiffviewClose",
        "DiffviewRefresh",
    },
    config = function()
        require "plugins.config.diffview.settings"
    end,
}
