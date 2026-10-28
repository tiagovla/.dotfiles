import Quickshell
import Quickshell.Io
import QtQuick
import "ProviderQuota.js" as Quota

Scope {
    id: root

    property var quota: null
    property string error: ""
    readonly property string label: error ? "Quota !" : quota ? "S " + quota.session.remaining + "% · " + quota.session.reset + "\nW " + quota.weekly.remaining + "% · " + quota.weekly.reset : "S --\nW --"
    readonly property string tooltip: {
        if (error)
            return "Provider quota unavailable\n" + error + "\nRefreshes every 5 minutes";
        if (!quota)
            return "Fetching provider quota…";
        return "Provider quota remaining\nSession: " + quota.session.remaining + "% left · reset in " + quota.session.reset
            + "\nWeekly: " + quota.weekly.remaining + "% left · reset in " + quota.weekly.reset
            + "\nRefreshes every 5 minutes";
    }

    function refresh(): void {
        if (!request.running)
            request.running = true;
    }

    Process {
        id: request
        command: ["python3", Quickshell.env("HOME") + "/.codex/scripts/fetch_omniroute_widget.py"]
        stdout: StdioCollector { id: response; waitForEnd: true }
        stderr: StdioCollector { id: diagnostic; waitForEnd: true }

        onExited: (exitCode, exitStatus) => {
            if (exitStatus !== 0 || exitCode !== 0) {
                root.error = exitCode === 28 ? "The request timed out." : (diagnostic.text.trim() || "Request failed.");
                return;
            }
            try {
                root.quota = Quota.parse(response.text);
                root.error = "";
            } catch (e) {
                root.error = "Unexpected provider quota response.";
            }
        }
    }

    Timer {
        interval: 5 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
