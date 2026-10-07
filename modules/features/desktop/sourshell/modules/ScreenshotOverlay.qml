import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    // mask: Region {}
    color: Qt.alpha(Colors.base00, 0.5)

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    function take() {
        if (selectionW != 0 && selectionH != 0) {
            console.log("Taking region screenshot");
        } else {
            console.log("Taking fullscreenshot");
        }

        root.visible = false;
    }

    property real selectionX: Math.min(input.startX, input.endX)
    property real selectionY: Math.min(input.startY, input.endY)
    property real selectionW: Math.abs(input.startX - input.endX)
    property real selectionH: Math.abs(input.startY - input.endY)

    property string cropString: `${Math.round(selectionX)},${Math.round(selectionY)} ${Math.round(selectionW)}x${Math.round(selectionH)}`
    onCropStringChanged: console.log(cropString)

    Shortcut {
        sequence: "Space"
        onActivated: {
            root.take();
        }
    }

    MouseArea {
        id: input
        anchors.fill: parent
        hoverEnabled: true

        property real startX: 0
        property real startY: 0
        property real endX: 0
        property real endY: 0

        onPressed: {
            startX = mouseX;
            startY = mouseY;
        }

        onReleased: {
            startX = 0;
            startY = 0;
            endX = 0;
            endY = 0;
        }

        onPositionChanged: {
            if (input.pressed) {
                endX = mouseX;
                endY = mouseY;
            }
        }
    }
}
