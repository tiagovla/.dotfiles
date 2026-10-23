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

    QsMenuOpener {
        id: trayMenuOpener
        menu: shell.activeTrayMenu
    }

    QsMenuOpener {
        id: traySubmenuOpener
        menu: shell.activeTraySubmenu
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: trayMenuPanel

            required property var modelData
            screen: modelData
            visible: shell.trayMenuVisible && modelData.name === shell.trayMenuScreenName
            color: shell.style.clear

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            WlrLayershell.namespace: "quickshell-tray-menu"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Ignore
            focusable: true

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onPressed: event => {
                    event.accepted = true;
                    shell.closeTrayMenu();
                }
                onClicked: event => {
                    event.accepted = true;
                    shell.closeTrayMenu();
                }
            }

            Rectangle {
                id: trayMenuCard

                x: Math.max(8, Math.min(shell.trayMenuX - width + 20, parent.width - width - 8))
                y: Math.max(8, Math.min(shell.trayMenuAnchorY + shell.trayMenuAnchorHeight + 6, parent.height - height - 8))
                width: shell.trayMenuWidth(trayMenuRepeater, 380, parent.width - 16)
                height: Math.max(64, Math.min(trayMenuColumn.implicitHeight + 16, parent.height - 16))
                radius: 12
                color: shell.style.trayMenuCard
                border.color: shell.style.divider
                border.width: 1
                clip: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: event => event.accepted = true
                }

                Flickable {
                    id: trayMenuFlickable

                    anchors.fill: parent
                    anchors.margins: 8
                    clip: true
                    contentWidth: width
                    contentHeight: trayMenuColumn.implicitHeight
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        id: trayMenuColumn
                        width: trayMenuFlickable.width
                        spacing: 2

                        Repeater {
                            id: trayMenuRepeater

                            model: trayMenuOpener.children

                            delegate: Rectangle {
                                id: trayMenuRow

                                required property DBusMenuItem modelData
                                property bool hovered: false
                                readonly property real naturalLabelWidth: trayMenuLabelMetrics.advanceWidth
                                width: trayMenuColumn.width
                                height: modelData.isSeparator ? 10 : 54
                                radius: 7
                                color: modelData.isSeparator ? shell.style.clear : hovered ? shell.style.hoverSurface : shell.style.clear

                                TextMetrics {
                                    id: trayMenuLabelMetrics
                                    text: trayMenuRow.modelData.text
                                    font.family: shell.style.textFontFamily
                                    font.pixelSize: 20
                                    font.bold: true
                                }

                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    height: 1
                                    color: shell.style.divider
                                    visible: trayMenuRow.modelData.isSeparator
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 10
                                    visible: !trayMenuRow.modelData.isSeparator

                                    Text {
                                        width: 24
                                        height: parent.height
                                        text: trayMenuRow.modelData.checkState === Qt.Checked ? (trayMenuRow.modelData.buttonType === QsMenuButtonType.RadioButton ? "●" : "✓") : ""
                                        color: shell.style.foreground
                                        font.family: shell.style.iconFontFamily
                                        font.pixelSize: 20
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Image {
                                        width: 24
                                        height: 24
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: shell.trayIconSource(trayMenuRow.modelData.icon)
                                        sourceSize: Qt.size(24, 24)
                                        fillMode: Image.PreserveAspectFit
                                        asynchronous: true
                                        visible: trayMenuRow.modelData.icon.length > 0
                                    }

                                    Text {
                                        width: Math.max(80, parent.width - 24 - 24 - 22 - parent.spacing * 3)
                                        height: parent.height
                                        text: trayMenuRow.modelData.text
                                        color: !trayMenuRow.modelData.enabled ? shell.style.disabled : shell.style.foreground
                                        font.family: shell.style.textFontFamily
                                        font.pixelSize: 20
                                        font.bold: true
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: 22
                                        height: parent.height
                                        text: trayMenuRow.modelData.hasChildren ? "›" : ""
                                        color: shell.style.foreground
                                        font.family: shell.style.textFontFamily
                                        font.pixelSize: 24
                                        horizontalAlignment: Text.AlignRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: trayMenuRow.modelData.enabled && !trayMenuRow.modelData.isSeparator
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: {
                                        trayMenuRow.hovered = true;
                                        shell.hoverTrayMenuEntry(trayMenuRow.modelData, trayMenuRow, 0, trayMenuPanel);
                                    }
                                    onExited: trayMenuRow.hovered = false
                                    onClicked: shell.activateTrayMenuEntry(trayMenuRow.modelData)
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: traySubmenuCard

                visible: shell.trayMenuVisible && shell.activeTraySubmenu !== null
                x: Math.max(8, Math.min(shell.traySubmenuX + width + 8 <= parent.width - 8 ? shell.traySubmenuX + 6 : trayMenuCard.x - width - 6, parent.width - width - 8))
                y: Math.max(8, Math.min(shell.traySubmenuY, parent.height - height - 8))
                width: shell.trayMenuWidth(traySubmenuRepeater, 360, parent.width - 16)
                height: Math.max(64, Math.min(traySubmenuColumn.implicitHeight + 16, parent.height - 16))
                radius: 12
                color: shell.style.trayMenuCard
                border.color: shell.style.divider
                border.width: 1
                clip: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: event => event.accepted = true
                }

                Flickable {
                    id: traySubmenuFlickable

                    anchors.fill: parent
                    anchors.margins: 8
                    clip: true
                    contentWidth: width
                    contentHeight: traySubmenuColumn.implicitHeight
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        id: traySubmenuColumn
                        width: traySubmenuFlickable.width
                        spacing: 2

                        Repeater {
                            id: traySubmenuRepeater

                            model: traySubmenuOpener.children

                            delegate: Rectangle {
                                id: traySubmenuRow

                                required property DBusMenuItem modelData
                                property bool hovered: false
                                readonly property real naturalLabelWidth: traySubmenuLabelMetrics.advanceWidth
                                width: traySubmenuColumn.width
                                height: modelData.isSeparator ? 10 : 54
                                radius: 7
                                color: modelData.isSeparator ? shell.style.clear : hovered ? shell.style.hoverSurface : shell.style.clear

                                TextMetrics {
                                    id: traySubmenuLabelMetrics
                                    text: traySubmenuRow.modelData.text
                                    font.family: shell.style.textFontFamily
                                    font.pixelSize: 20
                                    font.bold: true
                                }

                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    height: 1
                                    color: shell.style.divider
                                    visible: traySubmenuRow.modelData.isSeparator
                                }

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 10
                                    visible: !traySubmenuRow.modelData.isSeparator

                                    Text {
                                        width: 24
                                        height: parent.height
                                        text: traySubmenuRow.modelData.checkState === Qt.Checked ? (traySubmenuRow.modelData.buttonType === QsMenuButtonType.RadioButton ? "●" : "✓") : ""
                                        color: shell.style.foreground
                                        font.family: shell.style.iconFontFamily
                                        font.pixelSize: 20
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Image {
                                        width: 24
                                        height: 24
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: shell.trayIconSource(traySubmenuRow.modelData.icon)
                                        sourceSize: Qt.size(24, 24)
                                        fillMode: Image.PreserveAspectFit
                                        asynchronous: true
                                        visible: traySubmenuRow.modelData.icon.length > 0
                                    }

                                    Text {
                                        width: Math.max(80, parent.width - 24 - 24 - 22 - parent.spacing * 3)
                                        height: parent.height
                                        text: traySubmenuRow.modelData.text
                                        color: !traySubmenuRow.modelData.enabled ? shell.style.disabled : shell.style.foreground
                                        font.family: shell.style.textFontFamily
                                        font.pixelSize: 20
                                        font.bold: true
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: 22
                                        height: parent.height
                                        text: traySubmenuRow.modelData.hasChildren ? "›" : ""
                                        color: shell.style.foreground
                                        font.family: shell.style.textFontFamily
                                        font.pixelSize: 24
                                        horizontalAlignment: Text.AlignRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: traySubmenuRow.modelData.enabled && !traySubmenuRow.modelData.isSeparator
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: {
                                        traySubmenuRow.hovered = true;
                                        shell.hoverTrayMenuEntry(traySubmenuRow.modelData, traySubmenuRow, 1, trayMenuPanel);
                                    }
                                    onExited: traySubmenuRow.hovered = false
                                    onClicked: shell.activateTrayMenuEntry(traySubmenuRow.modelData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
