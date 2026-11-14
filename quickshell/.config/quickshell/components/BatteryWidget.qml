import Quickshell.Services.UPower
import QtQuick

Item {
    id: root

    required property var shell
    property var battery: UPower.displayDevice
    readonly property bool available: !!battery && battery.ready && battery.isPresent
    readonly property real level: available ? Math.max(0, Math.min(1, battery.percentage)) : 0
    readonly property bool charging: available && battery.state === UPowerDeviceState.Charging
    readonly property bool low: available && !charging && battery.state === UPowerDeviceState.Discharging && level < 0.2

    width: available ? content.implicitWidth : 0
    height: root.shell.barHeight
    visible: available

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 5

        Item {
            width: 23
            height: 20
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                x: 1
                y: 3
                width: 19
                height: 14
                radius: 3
                color: "transparent"
                border.color: root.shell.style.foreground
                border.width: 1.5
                opacity: mouse.containsMouse ? 0.2 : 1

                Rectangle {
                    x: 2
                    y: 2
                    width: Math.max(0, (parent.width - 4) * root.level)
                    height: parent.height - 4
                    radius: 1
                    color: root.low ? root.shell.style.red : root.charging ? root.shell.style.orangeAccent : root.shell.style.memoryAccent
                    opacity: root.low ? lowPulse.opacity : 1

                    Behavior on width { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
                }
            }

            Rectangle {
                x: 20
                y: 7
                width: 3
                height: 6
                radius: 1
                color: root.shell.style.foreground
                opacity: mouse.containsMouse ? 0.2 : 1
            }

            Text {
                objectName: "chargingIndicator"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: -3
                text: ""
                color: root.shell.style.orangeAccent
                font.family: root.shell.style.iconFontFamily
                font.pixelSize: 13
                font.bold: true
                style: Text.Outline
                styleColor: root.shell.style.selectedText
                visible: root.charging
                opacity: chargePulse.opacity
            }

            Text {
                objectName: "hoverPercentage"
                anchors.centerIn: parent
                text: Math.round(root.level * 100) + "%"
                color: root.shell.style.foreground
                font.family: root.shell.style.iconFontFamily
                font.pixelSize: 11
                font.bold: true
                style: Text.Outline
                styleColor: root.shell.style.selectedText
                visible: mouse.containsMouse
            }
        }

        Text {
            objectName: "percentageLabel"
            text: Math.round(root.level * 100) + "%"
            color: root.shell.style.foreground
            font.family: root.shell.style.iconFontFamily
            font.pixelSize: 17
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            visible: root.level < 0.7
            opacity: mouse.containsMouse ? 0 : 1
        }
    }

    MouseArea {
        id: mouse
        objectName: "batteryMouse"
        anchors.fill: parent
        hoverEnabled: true
    }

    SequentialAnimation {
        id: chargePulse
        running: root.visible === true && root.charging === true
        loops: Animation.Infinite
        NumberAnimation { target: chargePulse; property: "opacity"; from: 0.35; to: 1; duration: 650 }
        NumberAnimation { target: chargePulse; property: "opacity"; from: 1; to: 0.35; duration: 650 }
        property real opacity: 1
    }

    SequentialAnimation {
        id: lowPulse
        running: root.visible === true && root.low === true
        loops: Animation.Infinite
        NumberAnimation { target: lowPulse; property: "opacity"; from: 1; to: 0.35; duration: 700 }
        NumberAnimation { target: lowPulse; property: "opacity"; from: 0.35; to: 1; duration: 700 }
        property real opacity: 1
    }
}
