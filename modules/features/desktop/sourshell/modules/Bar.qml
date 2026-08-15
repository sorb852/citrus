import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.modules.barModules as BarModules

PanelWindow {
    anchors {
        left: true
        right: true
        bottom: true
    }
    WlrLayershell.layer: WlrLayer.Top
    implicitHeight: 32
    color: Colors.base01

    BarModules.Workspaces {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    BarModules.Clock {
        id: clock
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    RowLayout {
        spacing: 8
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: clock.left
        anchors.rightMargin: 8

        BarModules.CpuUsage {}
        Seperator {}
        BarModules.Battery {}
    }

    component Seperator: Rectangle {
        implicitWidth: 1
        implicitHeight: parent.height * 0.4
        color: Colors.base03
    }
}
