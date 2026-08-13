import QtQuick
import QtQuick.Layouts
import Quickshell.I3
import qs.services

RowLayout {
    id: root
    property int eventCount: 0 // Only here for reactivity

    Connections {
        target: I3
        function onRawEvent(event) {
            if (["workspace", "window"].includes(event.type))
                root.eventCount++;
        }
    }

    spacing: 0

    Repeater {

        // model: I3.workspaces
        model: 6

        delegate: Rectangle {
            id: unit
            required property var index

            property string name: String(index + 1)
            property I3Workspace workspace: {
                const _OHSWEETLOVEOFREACTION = root.eventCount;
                return I3.findWorkspaceByName(name);
            }

            property bool workspaceExists: workspace !== null

            implicitWidth: height
            Layout.fillHeight: true

            color: (!workspaceExists || !workspace.focused) ? Colors.base01 : Colors.base02

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    opacity: unit.workspaceExists && unit.workspace.focused ? 1 : 0
                    color: Colors.base09

                    Layout.fillWidth: true
                    Layout.preferredHeight: 3
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        anchors.centerIn: parent

                        text: unit.name
                        color: !unit.workspaceExists ? Colors.base03 : unit.workspace.focused ? Colors.base09 : Colors.base07
                        font.pixelSize: 16
                    }
                }
            }
        }
    }
}
