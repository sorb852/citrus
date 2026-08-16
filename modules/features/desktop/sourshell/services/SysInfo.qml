pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real cpuUsage: 0

    property real cpuTotalSinceBoot: 0
    property real cpuIdleSinceBoot: 0

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: fetchProc.running = true
    }

    Process {
        id: fetchProc
        command: ['head', '-n', '1', '/proc/stat']
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const stats = text.split(' ').filter(e => !['cpu', ''].includes(e)).map(Number);

                const currentIdle = stats[3];
                const currentTotal = stats.reduce((acc, e) => acc += e, 0);

                if (root.cpuTotalSinceBoot > 0) {
                    const idle = currentIdle - root.cpuIdleSinceBoot;
                    const total = currentTotal - root.cpuTotalSinceBoot;

                    root.cpuUsage = 1 - idle / total;
                }

                root.cpuIdleSinceBoot = currentIdle;
                root.cpuTotalSinceBoot = currentTotal;
            }
        }
    }

    Component.onCompleted: console.log("Sysinfo service up")
}
