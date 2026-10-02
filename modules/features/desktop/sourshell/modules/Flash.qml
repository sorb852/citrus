import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    visible: true
    focusable: false
    mask: Region {}
    WlrLayershell.keyboardFocus: KeyboardFocus.None
    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    IpcHandler {
        target: "freaky"
        function freakon() {
            animation.running = true;
        }
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    Image {
        NumberAnimation on opacity {
            id: animation
            easing: Easing.InSine
            duration: 2000
            from: 1
            to: 0
            running: false
        }
        opacity: 0.0
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        source: "chick.jpg"
    }
}
