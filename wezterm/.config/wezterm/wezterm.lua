local wezterm = require "wezterm"

return {
    enable_wayland = true,
    font = wezterm.font_with_fallback {
        {
            family = "MonolisaCode",
            weight = 600,
            harfbuzz_features = { -- https://www.monolisa.dev/specimen/code
                "zero=1", -- slashed zero 0
                "liga=1", -- ligatures
                "clig=1", -- coding ligatures
                "frac=0", -- fractions
                "ss01=1", -- enable italic
                "ss02=1", -- i and r
                "ss03=0", -- alt g
                "ss04=0", -- alt g
                "ss05=0", -- alt at @
                "ss06=0", -- alt at @
                "ss07=1", -- alt *
                "ss08=1", -- alt $
                "ss09=0", -- alt &
                "ss10=1", -- alt ()
                "ss11=1", -- alt {}
                "ss12=0", -- thin double backslash
                "ss13=0", -- hexadecimal x multiply
                "ss14=1", -- alt seven
                "ss15=0", -- plain 0
                "cv01=1", -- markdown headings
                "cv02=1", -- less, slash, greater
                "cv03=1", -- less, bar, greater
                "cv04=1", -- less, hyphen, greater
                "cv05=1", -- less, equal, greater
                "cv06=1", -- alt >= <= liga 1
                "cv07=1", -- alt >= <= liga 2
                "cv08=1", -- arrows
                "cv09=1", -- equal combinations
                "cv10=1", -- alt .= ...= ligatures
                "cv11=1", -- tilde combinations
                "cv12=1", -- ampersand combinations
            },
        },
        { family = "Symbols Nerd Font Mono" },
        { family = "JetBrainsMono Nerd Font Mono", weight = 500 },
    },
    font_size = 16.0,
    cursor_blink_rate = 0,
    exit_behavior = "Close",
    force_reverse_video_cursor = true,
    cell_width = 0.85,
    window_background_opacity = 1.00,
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
    default_prog = (function()
        local workspace_cmd = "$(hyprctl activeworkspace -j | jq '.id')"
        local tmux_cmd =
            string.format("tmux attach -t %s 2>/dev/null || tmux new -A -s %s", workspace_cmd, workspace_cmd)
        return { "/usr/bin/zsh", "-l", "-c", tmux_cmd }
    end)(),
    keys = {
        { key = "Tab", mods = "CTRL", action = wezterm.action { SendString = "\x1b[9;5u" } },
        { key = "i", mods = "CTRL", action = wezterm.action { SendString = "\x1b[105;5u" } },
        { key = "\r", mods = "SHIFT", action = wezterm.action { SendString = "\x1b[13;2u" } },
        { key = "\r", mods = "CTRL", action = wezterm.action { SendString = "\x1b[13;5u" } },
    },
    warn_about_missing_glyphs = false,
    webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[1],
    front_end = "WebGpu",
    debug_key_events = true,
    max_fps = 120,
    window_close_confirmation = "NeverPrompt",
}
