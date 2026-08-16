pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real brightness: 1
    readonly property int maxBrightness: Number(maxBrightnessFile.text())

    FileView {
        id: brightnessFile
        path: Qt.resolvedUrl("/sys/class/backlight/intel_backlight/brightness")
        watchChanges: true
        atomicWrites: false
        onFileChanged: this.reload()
        onLoaded: root.brightness = root._clamp(Number(this.text()) / root.maxBrightness)
    }

    FileView {
        id: maxBrightnessFile
        blockLoading: true
        path: Qt.resolvedUrl("/sys/class/backlight/intel_backlight/max_brightness")
    }

    function _clamp(v: real): real {
        return Math.min(1, Math.max(0.01, v));
    }

    function setBrightness(v: real) {
        root.brightness = root._clamp(v);
        root.sync();
    }

    function adjust(v: real) {
        root.brightness = root._clamp(root.brightness + v);
        root.sync();
    }

    function sync() {
        brightnessFile.setText(Math.floor(root.brightness * root.maxBrightness));
    }

    IpcHandler {
        target: "backlight"

        function get(): real {
            return root.brightness * 100;
        }

        function set(v: real): void {
            root.setBrightness(v / 100);
        }

        function inc(v: real): void {
            root.adjust(v / 100);
        }

        function dec(v: real): void {
            root.adjust(-(v / 100));
        }
    }

    Component.onCompleted: console.log("Backlight service up")
}
