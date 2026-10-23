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
            id: notificationPanel

            required property var modelData
            screen: modelData
            visible: shell.activeNotifications.length > 0 && modelData.name === shell.notificationScreenName
            color: shell.style.clear
            implicitWidth: 380
            implicitHeight: Math.max(48, Math.min(notificationFlickable.contentHeight + 16, modelData.height - shell.barHeight - 24))

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.namespace: "quickshell-notifications"

            anchors {
                top: true
                right: true
            }
            margins {
                top: shell.barHeight + 12
                right: 12
            }

            exclusionMode: ExclusionMode.Ignore
            focusable: false

            Flickable {
                id: notificationFlickable

                anchors.fill: parent
                anchors.margins: 8
                clip: true
                contentWidth: width
                contentHeight: notificationColumn.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: notificationColumn
                    width: notificationFlickable.width
                    spacing: 8

                    Repeater {
                        model: shell.activeNotifications

                        delegate: Rectangle {
                            id: notificationCard

                            required property var modelData
                            readonly property bool isCritical: modelData.urgency === NotificationUrgency.Critical
                            width: notificationColumn.width
                            height: notificationContent.implicitHeight + 24
                            radius: 12
                            color: shell.style.panelCard
                            border.color: isCritical ? shell.style.red : shell.style.subtleBorder
                            border.width: 1

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.AllButtons
                                onClicked: notificationCard.modelData.dismiss()
                            }

                            Column {
                                id: notificationContent

                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 6

                                Row {
                                    width: parent.width
                                    spacing: 8

                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: 9
                                        color: shell.style.notificationIconSurface

                                        Text {
                                            anchors.centerIn: parent
                                            text: ""
                                            color: shell.style.selected
                                            font.family: shell.style.iconFontFamily
                                            font.pixelSize: 19
                                        }

                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 4
                                            source: shell.trayIconSource(notificationCard.modelData.appIcon)
                                            sourceSize: Qt.size(24, 24)
                                            fillMode: Image.PreserveAspectFit
                                            asynchronous: true
                                            visible: notificationCard.modelData.appIcon.length > 0
                                        }
                                    }

                                    Column {
                                        width: parent.width - 32 - 24 - parent.spacing * 2
                                        spacing: 2

                                        Text {
                                            width: parent.width
                                            text: notificationCard.modelData.appName || "Notification"
                                            color: shell.style.secondaryText
                                            font.family: shell.style.textFontFamily
                                            font.pixelSize: 11
                                            font.bold: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            width: parent.width
                                            text: notificationCard.modelData.summary
                                            color: shell.style.foreground
                                            font.family: shell.style.textFontFamily
                                            font.pixelSize: 16
                                            font.bold: true
                                            wrapMode: Text.Wrap
                                            maximumLineCount: 2
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Rectangle {
                                        width: 24
                                        height: 24
                                        radius: 6
                                        color: notificationCloseMouse.containsMouse ? shell.style.hoverSurface : shell.style.clear
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: "×"
                                            color: shell.style.foreground
                                            font.family: shell.style.textFontFamily
                                            font.pixelSize: 21
                                        }

                                        MouseArea {
                                            id: notificationCloseMouse
                                            anchors.fill: parent
                                            acceptedButtons: Qt.AllButtons
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: notificationCard.modelData.dismiss()
                                        }
                                    }
                                }

                                Text {
                                    width: parent.width
                                    text: notificationCard.modelData.body
                                    color: shell.style.notificationBody
                                    font.family: shell.style.textFontFamily
                                    font.pixelSize: 13
                                    textFormat: Text.RichText
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 5
                                    elide: Text.ElideRight
                                    visible: text.length > 0
                                }

                                Flow {
                                    id: notificationActions

                                    width: parent.width
                                    spacing: 6
                                    visible: notificationActionRepeater.count > 0

                                    Repeater {
                                        id: notificationActionRepeater

                                        model: notificationCard.modelData.actions

                                        delegate: Rectangle {
                                            id: notificationActionButton

                                            required property var modelData
                                            width: Math.min(notificationActionLabel.implicitWidth + 20, notificationActions.width)
                                            height: 30
                                            radius: 7
                                            color: notificationActionMouse.containsMouse ? shell.style.subtleBorder : shell.style.contentBackground

                                            Text {
                                                id: notificationActionLabel
                                                anchors.fill: parent
                                                anchors.leftMargin: 10
                                                anchors.rightMargin: 10
                                                text: notificationActionButton.modelData.text
                                                color: shell.style.foreground
                                                font.family: shell.style.textFontFamily
                                                font.pixelSize: 12
                                                font.bold: true
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                elide: Text.ElideRight
                                            }

                                            MouseArea {
                                                id: notificationActionMouse
                                                anchors.fill: parent
                                                acceptedButtons: Qt.AllButtons
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: event => {
                                                    if (event.button === Qt.LeftButton)
                                                        notificationActionButton.modelData.invoke();
                                                    notificationCard.modelData.dismiss();
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Connections {
                                target: notificationCard.modelData
                                function onClosed(reason) {
                                    shell.removeNotification(notificationCard.modelData);
                                }
                            }

                            Timer {
                                interval: notificationCard.modelData.expireTimeout > 0 ? notificationCard.modelData.expireTimeout : 8000
                                running: notificationCard.modelData.expireTimeout !== 0
                                repeat: false
                                onTriggered: notificationCard.modelData.expire()
                            }
                        }
                    }
                }
            }
        }
    }
}
