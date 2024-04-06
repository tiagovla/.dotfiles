local wezterm = require "wezterm"

return {
    font = wezterm.font_with_fallback {
        {
            family = "Monolisa",
            weight = 500,
            harfbuzz_features = { -- https://www.monolisa.dev/playground
                "zero=1", -- slashed zero
                "ss01=1", -- normal asterisk *
                "ss02=1", -- script variant
                "ss03=0", -- alt g
                "ss04=0", -- alt g
                "ss05=1", -- alt sharp S
                "ss06=0", -- alt at @
                "ss07=1", -- alt curly bracket
                "ss08=1", -- alt parenthesis --> (
                "ss09=0", -- alt greater equal style 1
                "ss10=1", -- alt greater equal style 2 -> >=
                "ss11=1", -- hexadecimal -> 0x69
                "ss12=0", -- thin backslash -> //
                "ss13=1", -- alt dollar -> $
                "ss14=0", -- alt &
                "ss15=0", -- i without serif
                "ss16=0", -- r without serif
                "ss17=1", -- alt .= and ..=
            },
        },
        { family = "JetBrains Mono", weight = 500 },
    },
    font_size = 17.0,
    cursor_blink_rate = 0,
    exit_behavior = "Close",
    force_reverse_video_cursor = true,
    cell_width = 0.85,
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
    warn_about_missing_glyphs = false,
    -- webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[1],
    -- front_end = "WebGpu",
    debug_key_events = true,
}
