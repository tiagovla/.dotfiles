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
            id: calendarPanel

            required property var modelData
            screen: modelData
            visible: shell.calendarVisible && modelData.name === shell.calendarScreenName
            color: shell.style.clear

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.namespace: "quickshell-calendar"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Ignore
            focusable: false

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onPressed: event => {
                    event.accepted = true;
                    shell.calendarVisible = false;
                }
                onClicked: event => {
                    event.accepted = true;
                    shell.calendarVisible = false;
                }
            }

            Rectangle {
                width: 356
                height: 410
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: shell.barHeight + 8
                anchors.rightMargin: 12
                radius: 10
                color: shell.style.calendarCard
                border.color: shell.style.divider
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onPressed: event => event.accepted = true
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            radius: 7
                            color: previousMonthMouse.containsMouse ? shell.style.contentBackground : shell.style.clear

                            Text {
                                anchors.centerIn: parent
                                text: "‹"
                                color: shell.style.foreground
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 26
                            }

                            MouseArea {
                                id: previousMonthMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.moveCalendarMonth(-1)
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: Qt.formatDate(new Date(shell.calendarYear, shell.calendarMonth, 1), "MMMM yyyy")
                            color: shell.style.foreground
                            font.family: shell.style.textFontFamily
                            font.pixelSize: 19
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Rectangle {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            radius: 7
                            color: nextMonthMouse.containsMouse ? shell.style.contentBackground : shell.style.clear

                            Text {
                                anchors.centerIn: parent
                                text: "›"
                                color: shell.style.foreground
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 26
                            }

                            MouseArea {
                                id: nextMonthMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.moveCalendarMonth(1)
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 30
                            radius: 7
                            color: closeCalendarMouse.containsMouse ? shell.style.contentBackground : shell.style.clear

                            Text {
                                anchors.centerIn: parent
                                text: "×"
                                color: shell.style.foreground
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 20
                            }

                            MouseArea {
                                id: closeCalendarMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: shell.calendarVisible = false
                            }
                        }
                    }

                    Grid {
                        id: weekdayGrid
                        Layout.fillWidth: true
                        columns: 7
                        columnSpacing: 4
                        rowSpacing: 4

                        Repeater {
                            model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

                            delegate: Text {
                                required property string modelData
                                width: (weekdayGrid.width - 24) / 7
                                height: 24
                                text: modelData
                                color: shell.style.mutedText
                                font.family: shell.style.textFontFamily
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Grid {
                        id: calendarGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 7
                        columnSpacing: 4
                        rowSpacing: 4

                        Repeater {
                            model: 42

                            delegate: Rectangle {
                                id: calendarDay

                                required property int index

                                readonly property date cellDate: new Date(shell.calendarYear, shell.calendarMonth, index - new Date(shell.calendarYear, shell.calendarMonth, 1).getDay() + 1)
                                readonly property bool inDisplayedMonth: cellDate.getMonth() === shell.calendarMonth && cellDate.getFullYear() === shell.calendarYear
                                readonly property bool isToday: cellDate.getFullYear() === shell.currentTime.getFullYear() && cellDate.getMonth() === shell.currentTime.getMonth() && cellDate.getDate() === shell.currentTime.getDate()
                                readonly property bool isSelected: cellDate.getFullYear() === shell.selectedDate.getFullYear() && cellDate.getMonth() === shell.selectedDate.getMonth() && cellDate.getDate() === shell.selectedDate.getDate()
                                property bool hovered: false

                                width: (calendarGrid.width - 24) / 7
                                height: 36
                                radius: 7
                                color: isSelected ? shell.style.selected : hovered ? shell.style.contentBackground : isToday ? shell.style.subtleSurface : shell.style.clear

                                Text {
                                    anchors.centerIn: parent
                                    text: calendarDay.cellDate.getDate().toString()
                                    color: calendarDay.isSelected ? shell.style.selectedText : calendarDay.inDisplayedMonth ? shell.style.foreground : shell.style.disabled
                                    font.family: shell.style.textFontFamily
                                    font.pixelSize: 15
                                    font.bold: calendarDay.isToday || calendarDay.isSelected
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: calendarDay.hovered = true
                                    onExited: calendarDay.hovered = false
                                    onClicked: {
                                        shell.selectedDate = calendarDay.cellDate;
                                        shell.calendarYear = calendarDay.cellDate.getFullYear();
                                        shell.calendarMonth = calendarDay.cellDate.getMonth();
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: Qt.formatDate(shell.selectedDate, "dddd, MMMM d")
                        color: shell.style.mutedText
                        font.family: shell.style.textFontFamily
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
