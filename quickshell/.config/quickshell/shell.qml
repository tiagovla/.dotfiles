//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.DBusMenu
import Quickshell.Services.SystemTray
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "theme"

Scope {
    id: root

    readonly property var style: theme
    readonly property var packageUpdates: packageUpdatesService
    readonly property var providerQuota: providerQuotaService

    readonly property int barHeight: 40
    readonly property int statusIconSize: 22

    property bool launcherVisible: false
    property string launcherScreenName: ""
    property bool calendarVisible: false
    property string calendarScreenName: ""
    property bool trayMenuVisible: false
    property string trayMenuScreenName: ""
    property real trayMenuX: 0
    property real trayMenuY: 0
    property real trayMenuAnchorX: 0
    property real trayMenuAnchorY: 0
    property real trayMenuAnchorWidth: 0
    property real trayMenuAnchorHeight: 0
    property real traySubmenuX: 0
    property real traySubmenuY: 0
    property var activeTrayItem: null
    property QsMenuHandle activeTrayMenu: null
    property DBusMenuItem activeTraySubmenu: null
    property DBusMenuItem activeTraySubmenuEntry: null
    property int calendarMonth: new Date().getMonth()
    property int calendarYear: new Date().getFullYear()
    property date selectedDate: new Date()
    property string searchText: ""
    property string cpuUsage: "--"
    property string memoryUsed: "--"
    property string diskUsed: "--"
    property string volumePercent: "--"
    property bool volumeLevelVisible: false
    property int pendingVolumeSteps: 0
    property int pendingAudioMuteToggles: 0
    property bool pendingMicrophoneMuteUpdate: false
    property bool pendingMicrophoneMuteTarget: true
    property bool audioMuted: true
    property bool microphoneMuted: true
    property date currentTime: new Date()
    property var activeNotifications: []
    property string notificationScreenName: ""
    property int pendingNotificationSounds: 0
    readonly property var launcherApps: filteredApps

    Theme {
        id: theme
    }

    PackageUpdates {
        id: packageUpdatesService
    }

    ProviderQuota {
        id: providerQuotaService
    }

    function workspaceIcon(name: string): string {
        switch (name) {
        case "1": return "";
        case "2":
        case "3":
        case "4": return "";
        case "5": return "阮";
        case "6": return "ﭮ";
        case "7": return "金";
        case "8": return "";
        case "9": return "";
        case "10": return "";
        default: return "";
        }
    }

    function isSpotifyPlayer(player): bool {
        const identifiers = [player.identity, player.desktopEntry, player.dbusName];
        for (let i = 0; i < identifiers.length; i++) {
            if (identifiers[i] && String(identifiers[i]).toLowerCase().includes("spotify"))
                return true;
        }
        return false;
    }

    function focusSpotifyApp(player): void {
        const toplevels = Hyprland.toplevels.values;
        for (let i = 0; i < toplevels.length; i++) {
            const toplevel = toplevels[i];
            const ipc = toplevel.lastIpcObject || {};
            const identifiers = [ipc.class, ipc.initialClass, ipc.title, ipc.initialTitle, toplevel.title];
            let isSpotify = false;
            for (let j = 0; j < identifiers.length; j++) {
                if (identifiers[j] && String(identifiers[j]).toLowerCase().includes("spotify")) {
                    isSpotify = true;
                    break;
                }
            }

            if (!isSpotify)
                continue;

            if (toplevel.workspace)
                toplevel.workspace.activate();
            Hyprland.dispatch("focuswindow address:" + toplevel.address);
            return;
        }

        let spotifyApp = null;
        const applications = DesktopEntries.applications.values;
        for (let i = 0; i < applications.length; i++) {
            const app = applications[i];
            const name = String(app.name || "").toLowerCase();
            const id = String(app.id || "").toLowerCase();
            if (name === "spotify" || id.includes("spotify")) {
                spotifyApp = app;
                break;
            }
        }

        if (player.canRaise)
            player.raise();
        else if (spotifyApp)
            spotifyApp.execute();
    }

    function focusWorkspace(name: string): void {
        const request = "workspace " + name;
        if (Hyprland.usingLua) {
            const workspace = Number.isNaN(Number(name)) ? JSON.stringify(name) : Number(name);
            Hyprland.dispatch("hl.dsp.focus { workspace = " + workspace + " }");
        } else {
            Hyprland.dispatch(request);
        }
    }

    function trayIconSource(icon: string): string {
        if (!icon)
            return "";
        if (icon.startsWith("image://") || icon.startsWith("qrc:") || icon.startsWith(":/"))
            return icon;

        // NetworkManager animates connection by requesting numbered frames.
        // This machine has the base hicolor frames, but not their -secure
        // aliases, so resolve these frames directly to the installed assets.
        const networkIcon = icon.replace(/-secure$/, "");
        if (networkIcon === "nm-no-connection" || /^nm-stage\d{2}-connecting\d{2}$/.test(networkIcon))
            return "file:///usr/share/icons/hicolor/22x22/apps/" + networkIcon + ".png";

        if (icon.startsWith("/"))
            return "file://" + icon;
        if (icon.startsWith("file://"))
            return icon;
        return Quickshell.iconPath(icon);
    }

    function trayMenuWidth(menuRepeater, minimumWidth: real, availableWidth: real): real {
        let widestLabel = 0;
        for (let i = 0; menuRepeater && i < menuRepeater.count; i++) {
            const row = menuRepeater.itemAt(i);
            if (row)
                widestLabel = Math.max(widestLabel, row.naturalLabelWidth);
        }

        return Math.min(Math.max(minimumWidth, Math.ceil(widestLabel + 152)), availableWidth);
    }

    function showNotification(notification): void {
        queueNotificationSound();
        notification.tracked = true;
        notificationScreenName = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : (Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "");

        const previous = activeNotifications.find(item => item.id === notification.id);
        if (previous && previous !== notification)
            previous.tracked = false;

        const updated = [notification].concat(activeNotifications.filter(item => item.id !== notification.id));
        const overflow = updated.splice(4);
        activeNotifications = updated;
        for (let i = 0; i < overflow.length; i++)
            overflow[i].dismiss();
    }

    function removeNotification(notification): void {
        const index = activeNotifications.indexOf(notification);
        if (index >= 0) {
            const updated = activeNotifications.slice();
            updated.splice(index, 1);
            activeNotifications = updated;
        }
        notification.tracked = false;
    }

    function queueNotificationSound(): void {
        pendingNotificationSounds++;
        startNotificationSound();
    }

    function startNotificationSound(): void {
        if (pendingNotificationSounds <= 0 || notificationSoundProcess.running)
            return;
        pendingNotificationSounds--;
        notificationSoundProcess.running = true;
    }

    function launcherIconCandidates(icon: string): var {
        if (!icon)
            return [];
        if (icon.startsWith("image://") || icon.startsWith("qrc:") || icon.startsWith(":/"))
            return [icon];
        if (icon.startsWith("file://"))
            return [icon];
        if (icon.startsWith("/"))
            return ["file://" + icon];

        const home = Quickshell.env("HOME");
        const dataRoots = [];
        if (home)
            dataRoots.push(home + "/.local/share/icons");
        dataRoots.push("/usr/local/share/icons");
        dataRoots.push("/usr/share/icons");

        const themes = ["Papirus-Dark", "breeze-dark", "hicolor"];
        const roots = [];
        for (let themeIndex = 0; themeIndex < themes.length; themeIndex++) {
            for (let rootIndex = 0; rootIndex < dataRoots.length; rootIndex++)
                roots.push(dataRoots[rootIndex] + "/" + themes[themeIndex]);
        }

        const sizes = ["64x64", "48x48", "96x96", "42x42", "32x32", "24x24", "22x22", "16x16", "128x128"];
        const extensionMatch = icon.match(/\.(svg|png|xpm)$/i);
        const names = extensionMatch ? [icon] : [icon + ".svg", icon + ".png", icon + ".xpm"];
        const candidates = [];

        for (let rootIndex = 0; rootIndex < roots.length; rootIndex++) {
            for (let sizeIndex = 0; sizeIndex < sizes.length; sizeIndex++) {
                for (let nameIndex = 0; nameIndex < names.length; nameIndex++) {
                    candidates.push("file://" + roots[rootIndex] + "/" + sizes[sizeIndex] + "/apps/" + names[nameIndex]);
                }
            }
        }

        candidates.push(Quickshell.iconPath(icon));
        return candidates;
    }

    function fuzzyMatch(text: string, query: string): bool {
        text = text.toLowerCase();
        query = query.toLowerCase();

        let queryIndex = 0;
        for (let i = 0; i < text.length && queryIndex < query.length; i++) {
            if (text[i] === query[queryIndex])
                queryIndex++;
        }

        return queryIndex === query.length;
    }

    function showLauncher(screenName: string): void {
        calendarVisible = false;
        closeTrayMenu();
        launcherScreenName = screenName;
        searchText = "";
        launcherVisible = true;
    }

    function toggleCalendar(screenName: string): void {
        if (calendarVisible && calendarScreenName === screenName) {
            calendarVisible = false;
            return;
        }

        const today = new Date();
        calendarYear = today.getFullYear();
        calendarMonth = today.getMonth();
        selectedDate = today;
        closeTrayMenu();
        calendarScreenName = screenName;
        calendarVisible = true;
    }

    function openTrayMenu(item, x: real, y: real, screenName: string, itemX: real, itemY: real, itemWidth: real, itemHeight: real): bool {
        const menuRoot = item && item.menu ? item.menu : null;
        if (!menuRoot)
            return false;

        const clickedSameIcon = activeTrayItem === item || (
            trayMenuScreenName === screenName
            && x >= trayMenuAnchorX && x <= trayMenuAnchorX + trayMenuAnchorWidth
            && y >= trayMenuAnchorY && y <= trayMenuAnchorY + trayMenuAnchorHeight
        );
        if (trayMenuVisible && clickedSameIcon) {
            closeTrayMenu();
            return true;
        }

        closeTrayMenu();
        calendarVisible = false;
        launcherVisible = false;
        activeTrayItem = item;
        activeTrayMenu = menuRoot; // qmllint disable incompatible-type
        trayMenuScreenName = screenName;
        trayMenuX = x;
        trayMenuY = y;
        trayMenuAnchorX = itemX;
        trayMenuAnchorY = itemY;
        trayMenuAnchorWidth = itemWidth;
        trayMenuAnchorHeight = itemHeight;
        trayMenuVisible = true;
        return true;
    }

    function closeTrayMenu(): void {
        activeTraySubmenuEntry = null;
        activeTraySubmenu = null;
        activeTrayItem = null;
        activeTrayMenu = null;
        trayMenuVisible = false;
    }

    function hoverTrayMenuEntry(entry: DBusMenuItem, row, depth: int, panel): void {
        if (entry.hasChildren) {
            activeTraySubmenuEntry = entry;
            activeTraySubmenu = entry;
            const position = row.mapToItem(panel.contentItem, 0, 0);
            traySubmenuX = position.x + row.width;
            traySubmenuY = position.y;
        } else if (depth === 0 && activeTraySubmenuEntry) {
            activeTraySubmenuEntry = null;
            activeTraySubmenu = null;
        }
    }

    function activateTrayMenuEntry(entry: DBusMenuItem): void {
        if (entry.hasChildren) {
            activeTraySubmenuEntry = entry;
            activeTraySubmenu = entry;
            return;
        }

        entry.triggered();
        closeTrayMenu();
    }

    function toggleFocusedCalendar(): void {
        const focusedScreen = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
        const fallbackScreen = Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "";
        toggleCalendar(focusedScreen || fallbackScreen);
    }

    function moveCalendarMonth(offset: int): void {
        const nextMonth = new Date(calendarYear, calendarMonth + offset, 1);
        calendarYear = nextMonth.getFullYear();
        calendarMonth = nextMonth.getMonth();
    }

    function updateMetrics(output: string): void {
        const lines = output.trim().split("\n");
        if (lines.length < 3)
            return;

        cpuUsage = lines[0] || "--";
        memoryUsed = lines[1] || "--";
        diskUsed = lines[2] || "--";
    }

    function updateAudio(output: string): void {
        const lines = output.trim().split("\n");
        if (lines.length < 3)
            return;

        if (!audioVolumeProcess.running && pendingVolumeSteps === 0)
            volumePercent = lines[0] || "--";
        if (!audioToggleProcess.running && pendingAudioMuteToggles === 0)
            audioMuted = lines[1] === "1";
        if (!microphoneToggleProcess.running && !pendingMicrophoneMuteUpdate
                && (lines[2] === "0" || lines[2] === "1"))
            microphoneMuted = lines[2] === "1";
    }

    function toggleAudioMute(): void {
        audioMuted = !audioMuted;
        pendingAudioMuteToggles++;
        runAudioMuteToggle();
    }

    function runAudioMuteToggle(): void {
        if (audioToggleProcess.running || pendingAudioMuteToggles === 0)
            return;

        pendingAudioMuteToggles--;
        audioToggleProcess.running = true;
    }

    function toggleMicrophoneMute(): void {
        microphoneMuted = !microphoneMuted;
        pendingMicrophoneMuteTarget = microphoneMuted;
        pendingMicrophoneMuteUpdate = true;
        runMicrophoneMuteUpdate();
    }

    function runMicrophoneMuteUpdate(): void {
        if (microphoneToggleProcess.running || !pendingMicrophoneMuteUpdate)
            return;

        const target = pendingMicrophoneMuteTarget ? "1" : "0";
        pendingMicrophoneMuteUpdate = false;
        microphoneToggleProcess.command = ["wpctl", "set-mute", "@DEFAULT_SOURCE@", target];
        microphoneToggleProcess.running = true;
    }

    function queueVolumeAdjustment(steps: int): void {
        pendingVolumeSteps += steps;

        const currentVolume = Number.parseInt(volumePercent, 10);
        if (!Number.isNaN(currentVolume))
            volumePercent = String(Math.max(0, currentVolume + steps * 5));

        runVolumeAdjustment();
    }

    function runVolumeAdjustment(): void {
        if (audioVolumeProcess.running || pendingVolumeSteps === 0)
            return;

        const change = pendingVolumeSteps * 5;
        pendingVolumeSteps = 0;
        audioVolumeProcess.command = ["wpctl", "set-volume", "@DEFAULT_SINK@", Math.abs(change) + "%" + (change > 0 ? "+" : "-")];
        audioVolumeProcess.running = true;
    }

    function refreshAudioMetricsIfIdle(): void {
        if (!audioMetricsProcess.running
                && !audioToggleProcess.running
                && !audioVolumeProcess.running
                && !microphoneToggleProcess.running
                && pendingAudioMuteToggles === 0
                && !pendingMicrophoneMuteUpdate
                && pendingVolumeSteps === 0)
            audioMetricsProcess.running = true;
    }

    function toggleLauncher(): void {
        if (launcherVisible) {
            launcherVisible = false;
            return;
        }

        const focusedScreen = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "";
        const fallbackScreen = Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "";
        showLauncher(focusedScreen || fallbackScreen);
    }

    function launchApp(app): void {
        if (!app)
            return;

        app.execute();
        recordAppLaunch(app);
        launcherVisible = false;
    }

    function recordAppLaunch(app): void {
        if (!app.id)
            return;

        const previous = launcherHistoryData.appIds || [];
        launcherHistoryData.appIds = [app.id].concat(previous.filter(id => id !== app.id)).slice(0, 50);
        launcherHistoryFile.writeAdapter();
        launcherHistoryFile.waitForJob();
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            root.toggleLauncher();
        }
    }

    IpcHandler {
        target: "calendar"

        function toggle(): void {
            root.toggleFocusedCalendar();
        }
    }

    NotificationServer {
        id: notificationServer
        keepOnReload: true
        persistenceSupported: false
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: false
        bodyImagesSupported: false
        actionsSupported: true
        actionIconsSupported: false
        imageSupported: false
        inlineReplySupported: false

        onNotification: notification => root.showNotification(notification)
    }

    FileView {
        id: launcherHistoryFile
        preload: true
        blockLoading: true
        path: Quickshell.statePath("launcher-history.json")

        JsonAdapter {
            id: launcherHistoryData
            property var appIds: []
        }
    }

    ScriptModel {
        id: filteredApps

        values: {
            const history = launcherHistoryData.appIds || [];
            return DesktopEntries.applications.values.filter(app => root.fuzzyMatch(app.name, root.searchText)).sort((a, b) => {
                const aRecent = history.indexOf(a.id);
                const bRecent = history.indexOf(b.id);
                if (aRecent < 0 && bRecent < 0)
                    return a.name.localeCompare(b.name);
                if (aRecent < 0)
                    return 1;
                if (bRecent < 0)
                    return -1;
                return aRecent - bRecent || a.name.localeCompare(b.name);
            });
        }
    }

    Process {
        id: metricsProcess

        command: ["bash", "-lc", `export LC_ALL=C
cpu=$(top -bn1 | awk -F, '/Cpu/ { idle=$4; gsub(/[^0-9.]/, "", idle); printf "%d", 100-idle }')
memory=$(free -b | awk '$1 == "Mem:" { printf "%.0f", $3 / 1073741824 }')
disk=$(df -P / | awk 'NR == 2 { print $5 }')
printf '%s\\n' "$cpu" "$memory" "$disk"`]

        stdout: StdioCollector {
            id: metricsOutput
            waitForEnd: true
            onStreamFinished: {
                root.updateMetrics(metricsOutput.text);
            }
        }
    }

    Process {
        id: audioMetricsProcess

        command: ["bash", "-lc", `sink=$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null)
volume=$(printf '%s\\n' "$sink" | awk '{ for (i=1; i<=NF; i++) if ($i == "Volume:") { printf "%d", $(i+1) * 100; exit } }')
case "$sink" in *MUTED*) sink_muted=1 ;; *) sink_muted=0 ;; esac
source_muted=na
source=$(wpctl get-volume @DEFAULT_SOURCE@ 2>/dev/null)
if [ -n "$source" ]; then
    case "$source" in *MUTED*) source_muted=1 ;; *) source_muted=0 ;; esac
fi
printf '%s\\n' "$volume" "$sink_muted" "$source_muted"`]

        stdout: StdioCollector {
            id: audioMetricsOutput
            waitForEnd: true
            onStreamFinished: root.updateAudio(audioMetricsOutput.text)
        }
    }

    Process {
        id: audioToggleProcess
        command: ["wpctl", "set-mute", "@DEFAULT_SINK@", "toggle"]

        onRunningChanged: {
            if (running)
                return;

            root.runAudioMuteToggle();
            root.refreshAudioMetricsIfIdle();
        }
    }

    Process {
        id: audioVolumeProcess
        command: []

        onRunningChanged: {
            if (running)
                return;

            root.runVolumeAdjustment();
            root.refreshAudioMetricsIfIdle();
        }
    }

    Process {
        id: microphoneToggleProcess

        onRunningChanged: {
            if (running)
                return;

            root.runMicrophoneMuteUpdate();
            root.refreshAudioMetricsIfIdle();
        }
    }

    Process {
        id: notificationSoundProcess
        command: ["paplay", "/usr/share/sounds/freedesktop/stereo/dialog-information.oga"]

        onRunningChanged: {
            if (!running)
                root.startNotificationSound();
        }
    }

    Timer {
        id: volumeDisplayTimer
        interval: 1200
        onTriggered: root.volumeLevelVisible = false
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!metricsProcess.running)
                metricsProcess.running = true;
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!audioMetricsProcess.running
                    && !audioToggleProcess.running
                    && !audioVolumeProcess.running
                    && !microphoneToggleProcess.running
                    && root.pendingAudioMuteToggles === 0
                    && !root.pendingMicrophoneMuteUpdate
                    && root.pendingVolumeSteps === 0)
                audioMetricsProcess.running = true;
        }
    }

    Component.onCompleted: {
        metricsProcess.running = true;
        audioMetricsProcess.running = true;
    }

    Bar { shell: root }

    NotificationOverlay { shell: root }

    LauncherOverlay { shell: root }

    TrayMenuOverlay { shell: root }

    CalendarOverlay { shell: root }

}
