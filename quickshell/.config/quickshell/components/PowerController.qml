import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Scope {
    id: root

    property var battery: UPower.displayDevice
    readonly property bool ready: !!root.battery && root.battery.ready && root.battery.isPresent
    property bool batteryMode: root.ready && root.battery.state === UPowerDeviceState.Discharging

    PersistentProperties {
        id: alerts
        reloadableId: "battery-alerts"
        property int lastLevel: 100
    }

    function checkAlerts(): void {
        if (!ready)
            return;
        if (!batteryMode) {
            alerts.lastLevel = 100;
            return;
        }
        const percent = Math.round(battery.percentage * 100);
        if (!Number.isFinite(percent) || percent < 0 || percent > 100)
            return;
        const level = percent <= 5 ? 5 : percent <= 10 ? 10 : percent <= 20 ? 20 : 100;
        if (level >= alerts.lastLevel || notification.running)
            return;

        alerts.lastLevel = level;
        notification.command = ["notify-send", "--app-name=Battery",
            "--icon=" + (level <= 10 ? "battery-caution" : "battery-low"),
            "--urgency=" + (level <= 10 ? "critical" : "normal"),
            level <= 5 ? "Battery critically low" : "Battery low",
            percent + "% remaining. " + (level <= 5 ? "Connect the charger now." : "Connect the charger soon.")];
        notification.running = true;
    }

    onBatteryModeChanged: {
        alertTimer.restart();
    }
    onReadyChanged: {
        alertTimer.restart();
    }

    Connections {
        target: root.battery
        function onPercentageChanged(): void { alertTimer.restart(); }
    }

    Timer {
        id: alertTimer
        interval: 150
        onTriggered: root.checkAlerts()
    }

    Process {
        id: notification
        stderr: StdioCollector { id: notificationError; waitForEnd: true }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0 || exitStatus !== 0)
                console.warn(notificationError.text.trim() || "Failed to send battery alert");
            else
                root.checkAlerts();
        }
    }

    Component.onCompleted: {
        alertTimer.restart();
    }
}
