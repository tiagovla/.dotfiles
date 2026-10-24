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
            implicitWidth: Math.max(200, Math.min(340, notificationColumn.preferredWidth + 16))
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

                    property real preferredWidth: {
                        let result = 0;
                        for (let i = 0; i < notificationRepeater.count; i++) {
                            const card = notificationRepeater.itemAt(i);
                            if (card)
                                result = Math.max(result, card.preferredWidth);
                        }
                        return result;
                    }

                    Repeater {
                        id: notificationRepeater

                        model: shell.activeNotifications

                        delegate: Rectangle {
                            id: notificationCard

                            required property var modelData
                            readonly property bool isCritical: modelData.urgency === NotificationUrgency.Critical
                            readonly property string plainBody: String(modelData.body || "").replace(/<[^>]*>/g, " ").replace(/&nbsp;/g, " ")
                            readonly property real titleWidth: Math.max(appNameMetrics.advanceWidth, titleMetrics.advanceWidth) + 110
                            readonly property real messageWidth: bodyMetrics.advanceWidth + 28
                            readonly property real preferredWidth: Math.min(324, Math.max(titleWidth, messageWidth))
                            width: notificationColumn.width
                            height: notificationContent.implicitHeight + 36
                            radius: 14
                            color: shell.style.panelCard
                            border.color: isCritical ? shell.style.red : shell.style.subtleBorder
                            border.width: 1

                            TextMetrics {
                                id: appNameMetrics
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 13
                                font.bold: true
                                text: notificationCard.modelData.appName || "Notification"
                            }

                            TextMetrics {
                                id: titleMetrics
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 19
                                font.bold: true
                                text: notificationCard.modelData.summary
                            }

                            TextMetrics {
                                id: bodyMetrics
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 16
                                text: notificationCard.plainBody
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.AllButtons
                                onClicked: notificationCard.modelData.dismiss()
                            }

                            Column {
                                id: notificationContent

                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                                anchors.topMargin: 18
                                anchors.bottomMargin: 18
                                spacing: 8

                                Row {
                                    width: parent.width
                                    spacing: 8

                                    Rectangle {
                                        width: 38
                                        height: 38
                                        radius: 9
                                        color: shell.style.notificationIconSurface

                                        Text {
                                            anchors.centerIn: parent
                                            text: ""
                                            color: shell.style.selected
                                            font.family: shell.style.iconFontFamily
                                            font.pixelSize: 23
                                        }

                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 4
                                            source: shell.trayIconSource(notificationCard.modelData.appIcon)
                                            sourceSize: Qt.size(30, 30)
                                            fillMode: Image.PreserveAspectFit
                                            asynchronous: true
                                            visible: notificationCard.modelData.appIcon.length > 0
                                        }
                                    }

                                    Column {
                                        width: parent.width - 38 - 28 - parent.spacing * 2
                                        spacing: 2

                                        Text {
                                            width: parent.width
                                            text: notificationCard.modelData.appName || "Notification"
                                            color: shell.style.secondaryText
                                            font.family: shell.style.textFontFamily
                                            font.pixelSize: 13
                                            font.bold: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            width: parent.width
                                            text: notificationCard.modelData.summary
                                            color: shell.style.foreground
                                            font.family: shell.style.textFontFamily
                                            font.pixelSize: 19
                                            font.bold: true
                                            wrapMode: Text.Wrap
                                            maximumLineCount: 2
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 6
                                        color: notificationCloseMouse.containsMouse ? shell.style.hoverSurface : shell.style.clear
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: "×"
                                            color: shell.style.foreground
                                            font.family: shell.style.textFontFamily
                                            font.pixelSize: 25
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
                                    font.pixelSize: 16
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
                                            height: 36
                                            radius: 7
                                            color: notificationActionMouse.containsMouse ? shell.style.subtleBorder : shell.style.contentBackground

                                            Text {
                                                id: notificationActionLabel
                                                anchors.fill: parent
                                                anchors.leftMargin: 12
                                                anchors.rightMargin: 12
                                                text: notificationActionButton.modelData.text
                                                color: shell.style.foreground
                                                font.family: shell.style.textFontFamily
                                                font.pixelSize: 14
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
