import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.DBusMenu
import Quickshell.Services.SystemTray
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
    id: barScope

    required property var shell

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            screen: modelData
            implicitHeight: shell.barHeight
            color: shell.style.clear

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell-waybar"

            anchors {
                top: true
                left: true
                right: true
            }

            exclusiveZone: shell.barHeight
            exclusionMode: ExclusionMode.Normal

            Rectangle {
                anchors.fill: parent
                color: shell.style.barBackground
            }

            Row {
                id: workspaceRow

                anchors.left: parent.left
                anchors.leftMargin: 7
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Repeater {
                    model: Hyprland.workspaces

                    delegate: Rectangle {
                        id: workspaceButton

                        required property var modelData

                        readonly property bool belongsHere: modelData.monitor && modelData.monitor.name === bar.screen.name
                        readonly property bool isActive: modelData.active
                        readonly property color foregroundColor: hovered && !isActive ? shell.style.workspaceHover : (shell.style.workspaceIconColors[modelData.name] || shell.style.foreground)
                        visible: belongsHere && modelData.id > 0
                        width: workspaceContent.implicitWidth + 22
                        height: 32
                        radius: 10
                        property bool hovered: false
                        color: isActive ? (hovered ? shell.style.subtleBorder : shell.style.hoverSurface) : (hovered ? shell.style.selected : shell.style.clear)

                        Row {
                            id: workspaceContent

                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: workspaceButton.modelData.name
                                color: workspaceButton.foregroundColor
                                font.family: shell.style.iconFontFamily
                                font.pixelSize: 16
                                font.bold: true
                                height: 28
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                text: shell.workspaceIcon(workspaceButton.modelData.name)
                                color: workspaceButton.foregroundColor
                                font.family: shell.style.iconFontFamily
                                font.pixelSize: workspaceButton.modelData.name === "1" ? 17 : 23
                                height: 28
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: workspaceButton.hovered = true
                            onExited: workspaceButton.hovered = false
                            onClicked: shell.focusWorkspace(workspaceButton.modelData.name)
                        }
                    }
                }
            }

            Row {
                id: statusRow

                anchors.right: parent.right
                anchors.rightMargin: 7
                anchors.verticalCenter: parent.verticalCenter
                spacing: 9

                QuotaWidget { shell: barScope.shell }

                UpdatesWidget { shell: barScope.shell }

                Item {
                    id: cpuWidget
                    width: cpuContent.implicitWidth
                    height: bar.height

                    Row {
                        id: cpuContent
                        anchors.centerIn: parent
                        spacing: 4

                        StatusIcon {
                            text: ""
                            color: shell.style.orangeAccent
                            fontFamily: shell.style.iconFontFamily
                        }

                        Text {
                            text: shell.cpuUsage + "%"
                            color: shell.style.foreground
                            font.family: shell.style.iconFontFamily
                            font.pixelSize: 17
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: cpuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                Item {
                    id: memoryWidget
                    width: memoryContent.implicitWidth
                    height: bar.height

                    Row {
                        id: memoryContent
                        anchors.centerIn: parent
                        spacing: 4

                        StatusIcon {
                            text: "󰍛"
                            color: shell.style.memoryAccent
                            fontFamily: shell.style.iconFontFamily
                        }

                        Text {
                            text: shell.memoryUsed + "GB"
                            color: shell.style.foreground
                            font.family: shell.style.iconFontFamily
                            font.pixelSize: 17
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: memoryMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                Item {
                    id: storageWidget
                    width: storageContent.implicitWidth
                    height: bar.height

                    Row {
                        id: storageContent
                        anchors.centerIn: parent
                        spacing: 4

                        StatusIcon {
                            text: ""
                            color: shell.style.diskAccent
                            fontFamily: shell.style.iconFontFamily
                        }

                        Text {
                            text: shell.diskUsed
                            color: shell.style.foreground
                            font.family: shell.style.iconFontFamily
                            font.pixelSize: 17
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: storageMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                BatteryWidget { shell: barScope.shell }

                Row {
                    id: volumeMicRow
                    height: bar.height
                    spacing: statusRow.spacing
                    anchors.verticalCenter: parent.verticalCenter

                Item {
                    id: volumeWidget
                    width: shell.volumeLevelVisible ? 54 : volumeIcon.implicitWidth
                    height: 30
                    anchors.verticalCenter: parent.verticalCenter

                    StatusIcon {
                        id: volumeIcon
                        anchors.centerIn: parent
                        visible: !shell.volumeLevelVisible
                        text: {
                            if (shell.audioMuted)
                                return "󰖁";

                            const volume = Number.parseInt(shell.volumePercent, 10);
                            if (Number.isNaN(volume) || volume < 33)
                                return "󰕿";
                            if (volume < 66)
                                return "󰖀";
                            return "󰕾";
                        }
                        color: shell.audioMuted ? shell.style.volumeMuted : shell.style.orangeAccent
                        fontFamily: shell.style.iconFontFamily
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: shell.volumeLevelVisible
                        text: {
                            const volume = Number.parseFloat(shell.volumePercent);
                            return Number.isNaN(volume) ? shell.volumePercent + "%" : Math.round(volume) + "%";
                        }
                        color: shell.audioMuted ? shell.style.volumeMuted : shell.style.orangeAccent
                        font.family: shell.style.iconFontFamily
                        font.pixelSize: 14
                        font.bold: true
                    }

                    MouseArea {
                        id: volumeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: shell.toggleAudioMute()
                        onWheel: wheel => {
                            const delta = wheel.angleDelta.y || wheel.pixelDelta.y;
                            if (delta === 0)
                                return;

                            shell.queueVolumeAdjustment(delta > 0 ? 1 : -1);
                            shell.volumeLevelVisible = true;
                            volumeDisplayTimer.restart();
                            wheel.accepted = true;
                        }
                    }
                }

                StatusIcon {
                    id: microphoneLabel
                    text: shell.microphoneMuted ? "" : ""
                    color: shell.microphoneMuted ? shell.style.microphoneMuted : shell.style.microphoneUnmuted
                    fontFamily: shell.style.iconFontFamily
                    height: bar.height

                    MouseArea {
                        id: microphoneMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: shell.toggleMicrophoneMute()
                    }
                }
                }

                Row {
                    id: trayRow
                    height: bar.height
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0

                    Repeater {
                        model: SystemTray.items

                        delegate: Item {
                            id: trayDelegate

                            required property var modelData
                            width: 26
                            height: bar.height
                            visible: modelData.status !== 0

                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: shell.trayIconSource(trayDelegate.modelData.icon)
                                sourceSize: Qt.size(20, 20)
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                            }

                            MouseArea {
                                id: trayMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: event => {
                                    const item = trayDelegate.modelData;
                                    const position = trayMouse.mapToItem(bar.contentItem, event.x, event.y);
                                    const trayPosition = trayMouse.mapToItem(bar.contentItem, 0, 0);
                                    const openMenu = () => {
                                        const openedCustomMenu = shell.openTrayMenu(
                                            item,
                                            position.x,
                                            position.y,
                                            bar.modelData.name,
                                            trayPosition.x,
                                            trayPosition.y,
                                            trayDelegate.width,
                                            trayDelegate.height
                                        );
                                        if (!openedCustomMenu)
                                            item.display(bar, Math.round(position.x), Math.round(position.y));
                                    };

                                    if (event.button === Qt.LeftButton && item.onlyMenu && item.hasMenu) {
                                        openMenu();
                                    } else if (event.button === Qt.LeftButton) {
                                        item.activate();
                                    } else if (event.button === Qt.RightButton && item.hasMenu) {
                                        openMenu();
                                    } else if (event.button === Qt.RightButton || event.button === Qt.MiddleButton) {
                                        item.secondaryActivate();
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: clockPill

                    readonly property bool calendarOpen: shell.calendarVisible && shell.calendarScreenName === bar.screen.name

                    width: clockContent.implicitWidth + 20
                    height: 32
                    radius: 10
                    color: calendarOpen ? shell.style.launcherInset : clockMouse.containsMouse ? shell.style.subtleSurface : shell.style.clear
                    border.color: calendarOpen ? shell.style.selected : shell.style.clear
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Row {
                        id: clockContent
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "󰥔"
                            color: shell.style.selected
                            font.family: shell.style.iconFontFamily
                            font.pixelSize: 18
                            width: 20
                            height: 26
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: Qt.formatTime(shell.currentTime, "hh:mm")
                            color: clockPill.calendarOpen ? shell.style.selected : shell.style.foreground
                            font.family: shell.style.iconFontFamily
                            font.pixelSize: 17
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: clockMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: shell.toggleCalendar(bar.screen.name)
                    }
                }
            }

            Repeater {
                model: Mpris.players

                delegate: Rectangle {
                    id: musicWidget

                    required property var modelData
                    readonly property bool isSpotify: shell.isSpotifyPlayer(modelData)
                    readonly property bool isYtMusic: shell.isYtMusicPlayer(modelData)
                    readonly property bool isMusicPlayer: isSpotify || isYtMusic
                    readonly property color accent: isYtMusic ? shell.style.ytMusicRed : shell.style.spotifyGreen
                    anchors.centerIn: parent
                    width: isMusicPlayer ? Math.max(0, Math.min(320, parent.width - workspaceRow.width - statusRow.width - 32)) : 0
                    height: 32
                    radius: 16
                    color: shell.style.spotifyCard
                    border.color: shell.style.border
                    border.width: isMusicPlayer ? 1 : 0
                    visible: isMusicPlayer && shell.activeMusicPlayer() === modelData
                    z: 2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: shell.focusMusicApp(musicWidget.modelData, musicWidget.isYtMusic ? "youtube-music-desktop-app" : "Spotify")
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 10
                        spacing: 8

                        Item {
                            width: 24
                            height: parent.height

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: Quickshell.iconPath("youtube-music-desktop-app")
                                visible: musicWidget.isYtMusic
                            }

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                color: musicWidget.accent
                                font.family: shell.style.iconFontFamily
                                font.pixelSize: 22
                                visible: musicWidget.isSpotify
                            }
                        }

                        Column {
                            width: Math.max(0, parent.width - 20 - 84 - parent.spacing * 2)
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                width: parent.width
                                text: musicWidget.modelData.trackTitle || (musicWidget.isYtMusic ? "YouTube Music" : "Spotify")
                                color: shell.style.foreground
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 12
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width
                                text: musicWidget.modelData.trackArtist || ""
                                color: shell.style.secondaryText
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 10
                                elide: Text.ElideRight
                                visible: text.length > 0
                            }
                        }

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 12
                                color: spotifyPreviousMouse.containsMouse ? shell.style.hoverSurface : shell.style.clear

                                Text {
                                    anchors.centerIn: parent
                                    text: "⏮"
                                    color: musicWidget.modelData.canGoPrevious ? shell.style.foreground : shell.style.disabled
                                    font.family: shell.style.iconFontFamily
                                    font.pixelSize: 18
                                }

                                MouseArea {
                                    id: spotifyPreviousMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: musicWidget.modelData.canGoPrevious
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: musicWidget.modelData.previous()
                                }
                            }

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 12
                                color: spotifyToggleMouse.containsMouse ? shell.style.hoverSurface : shell.style.clear

                                Text {
                                    anchors.centerIn: parent
                                    text: musicWidget.modelData.isPlaying ? "⏸" : "▶"
                                    color: musicWidget.modelData.canTogglePlaying ? musicWidget.accent : shell.style.disabled
                                    font.family: shell.style.iconFontFamily
                                    font.pixelSize: 18
                                }

                                MouseArea {
                                    id: spotifyToggleMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: musicWidget.modelData.canTogglePlaying
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: musicWidget.modelData.togglePlaying()
                                }
                            }

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 12
                                color: spotifyNextMouse.containsMouse ? shell.style.hoverSurface : shell.style.clear

                                Text {
                                    anchors.centerIn: parent
                                    text: "⏭"
                                    color: musicWidget.modelData.canGoNext ? shell.style.foreground : shell.style.disabled
                                    font.family: shell.style.iconFontFamily
                                    font.pixelSize: 18
                                }

                                MouseArea {
                                    id: spotifyNextMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: musicWidget.modelData.canGoNext
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: musicWidget.modelData.next()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
