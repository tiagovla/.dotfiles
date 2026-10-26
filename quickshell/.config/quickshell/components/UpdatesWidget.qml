import QtQuick
import QtQuick.Controls

Item {
    id: root

    required property var shell
    width: content.implicitWidth
    height: shell.barHeight

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 4

        StatusIcon {
            text: "󰚰"
            color: root.shell.style.selected
            fontFamily: root.shell.style.iconFontFamily
        }

        Text {
            text: root.shell.packageUpdates.label
            color: root.shell.style.foreground
            font.family: root.shell.style.iconFontFamily
            font.pixelSize: 17
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.shell.packageUpdates.refresh()
    }

    ToolTip.visible: mouse.containsMouse
    ToolTip.delay: 500
    ToolTip.text: shell.packageUpdates.tooltip
}
