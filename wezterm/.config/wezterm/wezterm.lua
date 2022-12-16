local wezterm = require "wezterm"

return {
    font = wezterm.font_with_fallback {
        { family = "Monolisa", weight = "Medium" },
        { family = "JetBrains Mono", weight = "Medium" },
    },
    font_size = 15.0,
    cursor_blink_rate = 0,
    exit_behavior = "Close",
    force_reverse_video_cursor = true,
    cell_width = 0.9,
    colors = {
        foreground = "#a0A8CD",
        background = "#11121D",
        ansi = { "#32344a", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#ad8ee6", "#449dab", "#787c99" },
        brights = { "#444b6a", "#ff7a93", "#b9f27c", "#ff9e64", "#7da6ff", "#bb9af7", "#0db9d7", "#acb0d0" },
        cursor_fg = nil,
        cursor_border = "#a0A8CD",
    },
    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4,
    },
    default_prog = {
        "/usr/bin/zsh",
        "-l",
        "-c",
        "tmux attach -t $(bspc query -D -d focused --names) || tmux new-session -A -s $(bspc query -D -d focused --names)",
    },
    keys = {
        { key = "i", mods = "CTRL", action = wezterm.action { SendString = "\x1b[105;5u" } },
        { key = "\r", mods = "SHIFT", action = wezterm.action { SendString = "\x1b[13;2u" } },
        { key = "\r", mods = "CTRL", action = wezterm.action { SendString = "\x1b[13;5u" } },
    },
}
