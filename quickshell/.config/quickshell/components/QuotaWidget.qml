import QtQuick

Item {
    id: root

    required property var shell
    property bool percentagesOnly: false
    property real rightSpacing: 6
    width: shell.providerQuota.quota && !shell.providerQuota.error
        ? (percentagesOnly ? compactLabel.implicitWidth : content.implicitWidth) + rightSpacing
        : label.implicitWidth + rightSpacing
    height: shell.barHeight

    Column {
        id: content
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0
        visible: root.shell.providerQuota.quota !== null
            && !root.shell.providerQuota.error && !root.percentagesOnly

        Row {
            id: sessionLine
            spacing: 4

            Text {
                text: root.shell.providerQuota.quota ? "S " + root.shell.providerQuota.quota.session.remaining + "%" : ""
                color: root.shell.style.selected
                font.family: root.shell.style.iconFontFamily
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: root.shell.providerQuota.quota ? "· " + root.shell.providerQuota.quota.session.reset : ""
                color: root.shell.style.secondaryText
                font.family: root.shell.style.iconFontFamily
                font.pixelSize: 12
            }
        }

        Row {
            id: weeklyLine
            spacing: 4

            Text {
                text: root.shell.providerQuota.quota ? "W " + root.shell.providerQuota.quota.weekly.remaining + "%" : ""
                color: root.shell.style.selected
                font.family: root.shell.style.iconFontFamily
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: root.shell.providerQuota.quota ? "· " + root.shell.providerQuota.quota.weekly.reset : ""
                color: root.shell.style.secondaryText
                font.family: root.shell.style.iconFontFamily
                font.pixelSize: 12
            }
        }
    }

    Column {
        id: compactLabel
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        visible: root.shell.providerQuota.quota !== null
            && !root.shell.providerQuota.error && root.percentagesOnly

        Text {
            text: root.shell.providerQuota.quota ? "S " + root.shell.providerQuota.quota.session.remaining + "%" : ""
            color: root.shell.style.selected
            font.family: root.shell.style.iconFontFamily
            font.pixelSize: 12
            font.bold: true
        }

        Text {
            text: root.shell.providerQuota.quota ? "W " + root.shell.providerQuota.quota.weekly.remaining + "%" : ""
            color: root.shell.style.selected
            font.family: root.shell.style.iconFontFamily
            font.pixelSize: 12
            font.bold: true
        }
    }

    Text {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        visible: root.shell.providerQuota.quota === null || root.shell.providerQuota.error
        text: root.shell.providerQuota.label
        color: root.shell.providerQuota.error ? root.shell.style.red : root.shell.style.selected
        font.family: root.shell.style.iconFontFamily
        font.pixelSize: 12
        font.bold: true
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.percentagesOnly = !root.percentagesOnly
    }
}
