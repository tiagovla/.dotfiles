hl.monitor { output = "", mode = "preferred", position = "auto", scale = 1 }
hl.monitor { output = "eDP-1", mode = "2560x1600@240", position = "4480x0", scale = 1.33 }
hl.monitor { output = "HDMI-A-1", mode = "2560x1080@75", position = "1920x0", scale = 1.00 }
hl.monitor { output = "DP-1", mode = "1920x1200@60", position = "640x0", scale = 1.5 }

for i = 1, 10 do
    hl.workspace_rule {
        workspace = i,
        monitor = "HDMI-A-1",
        default = (i == 1),
    }
end
hl.workspace_rule { workspace = "11", monitor = "DP-1", default = true }
hl.workspace_rule { workspace = "12", monitor = "eDP-1", default = true }

hl.on("hyprland.start", function()
    hl.exec_cmd "qs"
    hl.exec_cmd "copyq"
    hl.exec_cmd "nm-applet --indicator"
    hl.exec_cmd "hyprpaper"
    hl.exec_cmd "localsend --hidden"
    hl.exec_cmd "wl-clip-persist --clipboard regular"
    hl.exec_cmd "~/.cargo/bin/clip-bridge"
    hl.exec_cmd "wlsunset -l -23.55 -L -46.64 -T 5500 -t 4500"
    hl.exec_cmd [[hyprctl dispatch 'hl.dsp.focus({workspace="1"})']]
    hl.exec_cmd "sleep 5 && hyprctl reload"
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XCOMPOSEFILE", "~/.XCompose")
hl.env("WAYLAND_DISPLAY", "")

--animations
hl.config {
    general = {
        gaps_in = 3,
        gaps_out = 4,
        border_size = 1,
        col = {
            active_border = { colors = { "rgb(353b45)" } },
            inactive_border = "rgb(282c34)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 0.99,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
}

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.animation { leaf = "global", enabled = true, speed = 10, bezier = "default" }
hl.animation { leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" }
hl.animation { leaf = "windows", enabled = true, speed = 4.79, spring = "easy" }
hl.animation { leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" }
hl.animation { leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" }
hl.animation { leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" }
hl.animation { leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" }
hl.animation { leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" }
hl.animation { leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" }
hl.animation { leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" }
hl.animation { leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" }
hl.animation { leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" }
hl.animation { leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" }
hl.animation { leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }
hl.animation { leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" }

--config
hl.config {
    master = {
        new_status = "slave",
    },
    dwindle = {
        force_split = 2,
        preserve_split = true,
        split_width_multiplier = 1.3,
        default_split_ratio = 0.9,
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    layers = {
        layers_hog_keyboard_focus = false,
    },
    cursor = {
        no_hardware_cursors = 1,
    },
    input = {
        kb_layout = "us",
        kb_variant = "intl",
        kb_model = "pc105",
        kb_options = "",
        kb_rules = "",
        repeat_delay = 200,
        repeat_rate = 100,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
}

hl.gesture {
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
}

-- binds
hl.bind("ALT + W", hl.dsp.exec_cmd "firefox-nightly")
hl.bind("ALT + RETURN", hl.dsp.exec_cmd "wezterm")
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind(
    "SHIFT + ALT + Q",
    hl.dsp.exec_cmd "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
)
hl.bind("ALT + E", hl.dsp.exec_cmd "dolphin")
hl.bind("ALT + S", hl.dsp.window.float { action = "toggle" })
hl.bind("ALT + SPACE", hl.dsp.exec_cmd "qs ipc call launcher toggle || rofi -show drun")
-- hl.bind("ALT + P", hl.dsp.window.pseudo())
hl.bind("ALT + h", hl.dsp.focus { direction = "left" })
hl.bind("ALT + j", hl.dsp.focus { direction = "down" })
hl.bind("ALT + k", hl.dsp.focus { direction = "up" })
hl.bind("ALT + l", hl.dsp.focus { direction = "right" })

for i = 1, 10 do
    local key = i % 10
    hl.bind("ALT + " .. key, hl.dsp.focus { workspace = i })
    hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end

hl.bind("ALT + dead_grave", hl.dsp.focus { workspace = 11 })
hl.bind("ALT + minus", hl.dsp.focus { workspace = 12 })
hl.bind("ALT + SHIFT + dead_grave", hl.dsp.window.move { workspace = 11 })
hl.bind("ALT + SHIFT + minus", hl.dsp.window.move { workspace = 12 })
hl.bind("ALT + A", hl.dsp.workspace.toggle_special "magic")
hl.bind("ALT + SHIFT + A", hl.dsp.window.move { workspace = "special:magic" })
hl.bind("ALT + mouse_down", hl.dsp.focus { workspace = "e+1" })
hl.bind("ALT + mouse_up", hl.dsp.focus { workspace = "e-1" })
hl.bind("ALT + M", hl.dsp.window.fullscreen { mode = 1 })
hl.bind("ALT + SHIFT + Y", hl.dsp.window.pin { action = "toggle" })
hl.bind("ALT + SHIFT + M", hl.dsp.window.fullscreen { mode = 0 })

hl.bind(
    "ALT + P",
    hl.dsp.exec_cmd [[sh -c 'grim -g "$(slurp)" - | tee >(wl-copy) > "$HOME/Pictures/screenshots/screenshot-$(date +%F_%T).png" && dunstify "Screenshot of the region taken" -t 5000']]
)
hl.bind(
    "ALT + SHIFT + P",
    hl.dsp.exec_cmd [[sh -c 'file="$HOME/Pictures/screenshots/screenshot-$(date +%F_%T).png"; grim -o "$(hyprctl activeworkspace | head -n1 | awk -F"on monitor " "{print \$2}" | cut -d: -f1)" "$file" && wl-copy < "$file" && dunstify "Screenshot of whole screen taken" -t 5000']]
)

local mouse_drag = hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
local mouse_resize = hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%+", { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%-", { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd "playerctl next", { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd "playerctl play-pause", { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd "playerctl play-pause", { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd "playerctl previous", { locked = true })

-- window rules

hl.window_rule {
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
}

hl.window_rule {
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
}

hl.window_rule {
    name = "steam",
    match = {
        class = "steam",
    },
    workspace = "7 silent",
}

hl.window_rule {
    name = "discord",
    match = {
        class = "discord",
    },
    workspace = "12 silent",
}

hl.window_rule {
    name = "spotify",
    match = {
        class = "Spotify",
    },
    workspace = "5 silent",
}

hl.window_rule {
    name = "jellyfin",
    match = {
        class = "org.jellyfin.JellyfinDesktop",
    },
    workspace = "11 silent",
}

hl.window_rule {
    name = "pavucontrol",
    match = {
        class = "org.pulseaudio.pavucontrol",
    },
    float = true,
    center = true,
    size = "800 600",
}

hl.window_rule {
    name = "bitwarden",
    match = {
        class = "bitwarden",
    },
    float = true,
    center = true,
    size = "1200 800",
}

hl.on("window.active", function(w)
    local enabled = w.fullscreen == 0
    mouse_drag:set_enabled(enabled)
    mouse_resize:set_enabled(enabled)
end)
hl.on("window.fullscreen", function(w)
    local enabled = w.fullscreen == 0
    mouse_drag:set_enabled(enabled)
    mouse_resize:set_enabled(enabled)
end)

local counter = 0

hl.on("monitor.added", function(m)
    counter = counter + 1
    if m.name == "HDMI-A-1" then
        for i = 1, 10 do
            local n = i % 10
            hl.dsp.workspace.move { workspace = n, monitor = m.name }
        end
    end
    if m.name == "DP-1" then
        hl.dsp.workspace.move { workspace = 11, monitor = m.name }
    end
end)

hl.on("monitor.removed", function(m)
    if m.name == "HDMI-A-1" then
        for i = 1, 10 do
            local n = i % 10
            hl.dsp.workspace.move { workspace = n, monitor = "HDMI-A-1" }
        end
    end
    if m.name == "DP-1" then
        hl.dsp.workspace.move { workspace = 11, monitor = "HDMI-A-1" }
    end
end)
