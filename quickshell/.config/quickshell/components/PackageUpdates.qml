import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

    property int count: -1
    property string error: ""
    property var packages: []
    readonly property bool checking: checkProcess.running
    readonly property string label: checking ? "…" : error ? "!" : count < 0 ? "--" : String(count)
    readonly property string tooltip: {
        if (checking)
            return "Checking for paru updates…";
        if (error)
            return "Update check failed\n" + error + "\nClick to retry";
        if (count < 0)
            return "Click to check for paru updates";

        const summary = count === 0 ? "System is up to date" : count + " package update" + (count === 1 ? "" : "s") + " available";
        const preview = packages.slice(0, 15).join("\n");
        const overflow = count > 15 ? "\n… and " + (count - 15) + " more" : "";
        return summary + (preview ? "\n" + preview + overflow : "")
            + "\nRepository packages use the local pacman database."
            + "\nClick to refresh · Checks every 30 minutes";
    }

    function refresh(): void {
        if (!checkProcess.running) {
            error = "";
            checkProcess.running = true;
        }
    }

    Process {
        id: checkProcess

        // Query only: never sync the system database or install packages.
        command: ["timeout", "90s", "env", "LC_ALL=C", "paru", "-Qu", "--color", "never"]
        stdout: StdioCollector { id: checkOutput; waitForEnd: true }
        stderr: StdioCollector { id: checkError; waitForEnd: true }

        onExited: (exitCode, exitStatus) => {
            const output = checkOutput.text.trim();
            const diagnostic = checkError.text.trim();
            // pacman's empty upgrade query can return 1 without diagnostics.
            if (exitStatus !== 0 || (exitCode !== 0 && !(exitCode === 1 && !output && !diagnostic))) {
                root.error = exitCode === 124 ? "The request timed out." : (diagnostic || "paru exited with code " + exitCode);
                return;
            }

            root.packages = output.split("\n").filter(line => /^\S+\s+\S+\s+->\s+\S+/.test(line));
            root.count = root.packages.length;
            root.error = "";
        }
    }

    Timer {
        interval: 30 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
