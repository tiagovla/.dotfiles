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
    required property var shell

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: launcherPanel

            required property var modelData
            screen: modelData
            visible: shell.launcherVisible && modelData.name === shell.launcherScreenName
            color: shell.style.clear

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "quickshell-launcher"

            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: shell.launcherVisible = false
            }

            Rectangle {
                anchors.fill: parent
                color: shell.style.scrim
            }

            Rectangle {
                id: launcherBox

                anchors.centerIn: parent
                width: Math.min(parent.width * 0.64, 920)
                height: Math.min(parent.height * 0.78, 680)
                radius: 20
                color: shell.style.panelCard
                border.color: shell.style.border
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: event => event.accepted = true
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 28
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: shell.searchText.length > 0 ? shell.launcherApps.values.length + " results" : "Applications · recent first"
                            color: shell.style.foreground
                            font.family: shell.style.textFontFamily
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "ARROWS TO NAVIGATE  ·  ENTER TO OPEN"
                            color: shell.style.placeholder
                            font.family: shell.style.textFontFamily
                            font.pixelSize: 10
                            font.bold: true
                        }
                    }

                    Rectangle {
                        id: inputBar

                        Layout.fillWidth: true
                        Layout.preferredHeight: 62
                        radius: 12
                        color: shell.style.launcherInset
                        border.width: 0

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 18
                            anchors.rightMargin: 14
                            spacing: 14

                            Text {
                                text: "⌕"
                                color: shell.style.selected
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 26
                            }

                            TextField {
                                id: searchField

                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                placeholderText: "Search applications"
                                text: shell.searchText
                                onTextChanged: shell.searchText = text
                                focus: shell.launcherVisible
                                color: shell.style.foreground
                                placeholderTextColor: shell.style.placeholder
                                selectionColor: shell.style.selected
                                selectedTextColor: shell.style.selectedText
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 18
                                leftPadding: 0
                                cursorDelegate: Rectangle {
                                    width: 2
                                    color: shell.style.selected
                                    visible: searchField.activeFocus
                                }

                                background: Item {}

                                Keys.onPressed: event => {
                                    switch (event.key) {
                                    case Qt.Key_Down:
                                        if (appGrid.count > 0)
                                            appGrid.currentIndex = Math.min(Math.max(appGrid.currentIndex, 0) + 3, appGrid.count - 1);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Up:
                                        if (appGrid.count > 0)
                                            appGrid.currentIndex = Math.max(appGrid.currentIndex < 0 ? 0 : appGrid.currentIndex - 3, 0);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Right:
                                        if (appGrid.count > 0)
                                            appGrid.currentIndex = Math.min(Math.max(appGrid.currentIndex, 0) + 1, appGrid.count - 1);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Left:
                                        if (appGrid.count > 0)
                                            appGrid.currentIndex = Math.max(appGrid.currentIndex < 0 ? 0 : appGrid.currentIndex - 1, 0);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Return:
                                    case Qt.Key_Enter:
                                        if (appGrid.currentIndex >= 0)
                                            shell.launchApp(shell.launcherApps.values[appGrid.currentIndex]);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Escape:
                                        if (searchField.text.length > 0)
                                            searchField.clear();
                                        else
                                            shell.launcherVisible = false;
                                        event.accepted = true;
                                        break;
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 24
                                radius: 6
                                color: shell.style.launcherSelection

                                Text {
                                    anchors.centerIn: parent
                                    text: "ESC"
                                    color: shell.style.foreground
                                    font.family: shell.style.textFontFamily
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }
                        }
                    }

                    GridView {
                        id: appGrid

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        clip: true
                        interactive: true
                        keyNavigationEnabled: false
                        cellWidth: width / 3
                        cellHeight: height / 3

                        WheelHandler {
                            target: null

                            onWheel: event => {
                                const wheelDelta = event.pixelDelta.y !== 0 ? event.pixelDelta.y : event.angleDelta.y;
                                if (wheelDelta === 0)
                                    return;

                                const maxContentY = Math.max(0, appGrid.contentHeight - appGrid.height);
                                appGrid.contentY = Math.max(0, Math.min(maxContentY, appGrid.contentY - wheelDelta * 1.5));
                                event.accepted = true;
                            }
                        }

                        model: shell.launcherApps
                        currentIndex: count > 0 ? 0 : -1

                        onCountChanged: currentIndex = count > 0 ? 0 : -1

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            interactive: true
                            width: 10

                            contentItem: Rectangle {
                                implicitWidth: 6
                                radius: width / 2
                                color: shell.style.selected
                                opacity: parent.active ? 0.85 : 0.45
                            }

                            background: Rectangle {
                                color: shell.style.launcherInset
                                radius: width / 2
                                opacity: 0.65
                            }
                        }

                        delegate: Rectangle {
                            id: appDelegate

                            required property var modelData
                            required property int index
                            readonly property bool isSelected: GridView.isCurrentItem

                            width: appGrid.cellWidth
                            height: appGrid.cellHeight
                            color: shell.style.clear
                            border.width: 0

                            Rectangle {
                                id: appTile

                                anchors.centerIn: parent
                                width: parent.width * 0.9
                                height: parent.height * 0.9
                                radius: 10
                                color: appDelegate.isSelected ? shell.style.selected : appMouse.containsMouse ? shell.style.subtleSurface : shell.style.clear
                                border.color: appDelegate.isSelected ? shell.style.foreground : shell.style.clear
                                border.width: appDelegate.isSelected ? 2 : 0
                            }

                            Column {
                                anchors.centerIn: parent
                                width: parent.width - 4
                                spacing: 6

                                Image {
                                    id: appIconImage
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    property var iconCandidates: shell.launcherIconCandidates(appDelegate.modelData.icon)
                                    property int iconCandidateIndex: 0
                                    sourceSize: Qt.size(64, 64)
                                    width: 64
                                    height: 64
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true

                                    function loadNextIcon(): void {
                                        if (iconCandidateIndex >= iconCandidates.length)
                                            return;
                                        source = iconCandidates[iconCandidateIndex++];
                                    }

                                    Component.onCompleted: loadNextIcon()
                                    onStatusChanged: {
                                        if (status === Image.Error)
                                            loadNextIcon();
                                    }
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: Math.max(0, appTile.width - 16)
                                    text: appDelegate.modelData.name
                                    color: appDelegate.isSelected ? shell.style.selectedText : shell.style.foreground
                                    font.family: shell.style.textFontFamily
                                    font.pixelSize: 16
                                    font.bold: appDelegate.isSelected
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.NoWrap
                                    elide: Text.ElideRight
                                    clip: true
                                }
                            }

                            MouseArea {
                                id: appMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: appGrid.currentIndex = appDelegate.index
                                onClicked: shell.launchApp(appDelegate.modelData)
                            }
                        }

                        onCurrentIndexChanged: {
                            if (currentIndex >= 0)
                                positionViewAtIndex(currentIndex, GridView.Contain);
                        }
                    }
                }
            }
        }
    }
}
