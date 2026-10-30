import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
    required property var shell

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: shell.webSearchVisible && modelData.name === shell.webSearchScreenName
            color: shell.style.clear

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "quickshell-websearch"

            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: shell.style.scrim

                MouseArea {
                    anchors.fill: parent
                    onClicked: shell.webSearchVisible = false
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: Math.min(parent.width * 0.5, Math.max(720, queryMetrics.implicitWidth + 136))
                height: 86
                radius: 16
                color: shell.style.panelCard
                border.color: shell.style.border
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: event => event.accepted = true
                }

                Text {
                    id: queryMetrics
                    text: searchField.text
                    font: searchField.font
                    visible: false
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 22
                    spacing: 14

                    Text {
                        text: "⌕"
                        color: shell.style.selected
                        font.family: shell.style.textFontFamily
                        font.pixelSize: 28
                    }

                    TextField {
                        id: searchField

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "Search web · !gpt · !gh · !reddit"
                        text: shell.webSearchText
                        onTextChanged: shell.webSearchText = text
                        onAccepted: shell.submitWebSearch(text)
                        focus: shell.webSearchVisible
                        color: shell.style.foreground
                        placeholderTextColor: shell.style.placeholder
                        selectionColor: shell.style.selected
                        selectedTextColor: shell.style.selectedText
                        font.family: shell.style.textFontFamily
                        font.pixelSize: 20
                        leftPadding: 0

                        cursorDelegate: Rectangle {
                            width: 2
                            color: shell.style.selected
                            visible: searchField.activeFocus
                        }

                        background: Item {}

                        Keys.onEscapePressed: shell.webSearchVisible = false
                    }
                }
            }
        }
    }
}
