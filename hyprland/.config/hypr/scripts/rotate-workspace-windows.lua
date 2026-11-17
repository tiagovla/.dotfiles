return function(direction)
    local monitors = {}
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.enabled and not monitor.is_mirror then
            table.insert(monitors, monitor)
        end
    end
    if #monitors < 2 then
        return
    end

    table.sort(monitors, function(a, b)
        return a.x < b.x or (a.x == b.x and a.y < b.y)
    end)

    local current = hl.get_active_monitor()
    if not current then
        return
    end
    local index
    for i, monitor in ipairs(monitors) do
        if monitor.id == current.id then
            index = i
            break
        end
    end
    if not index then
        return
    end

    local neighbor = monitors[(index - 1 + direction) % #monitors + 1]
    local source = current.active_workspace
    local target = neighbor.active_workspace
    if not source or not target then
        return
    end

    local source_id, target_id = source.id, target.id
    local rename_sessions = string.format(
        "%q '%s' '%s'",
        os.getenv("HOME") .. "/.config/hypr/scripts/swap-tmux-workspace-sessions.sh",
        source.name:gsub("'", "'\\''"),
        target.name:gsub("'", "'\\''")
    )
    local focused_window = hl.get_active_window()
    -- Snapshot both sets before moving; pinned windows stay on their monitor.
    local source_windows = hl.get_windows { workspace = source, mapped = true }
    local target_windows = hl.get_windows { workspace = target, mapped = true }
    for _, window in ipairs(source_windows) do
        if not window.pinned then
            hl.dispatch(hl.dsp.window.move { window = window, workspace = target_id, follow = false })
        end
    end
    for _, window in ipairs(target_windows) do
        if not window.pinned then
            hl.dispatch(hl.dsp.window.move { window = window, workspace = source_id, follow = false })
        end
    end
    hl.dispatch(hl.dsp.focus { workspace = target_id })
    if focused_window and focused_window.workspace and focused_window.workspace.id == target_id then
        hl.dispatch(hl.dsp.focus { window = focused_window })
    end
    -- Hyprland reaps child processes, so os.execute() can report failure after the command succeeds.
    hl.exec_cmd(rename_sessions)
end
