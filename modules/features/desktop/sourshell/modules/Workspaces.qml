import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3
import qs.services

Item {
    id: root
    property int eventCount: 0 // Only here for reactivity

    PersistentProperties {
        id: persist
        reloadableId: "persistedStates"
        property bool init: false
    }

    Connections {
        target: I3

        function onRawEvent(event) {
            if (event.type === "get_workspaces")
                persist.init = true;
            if (["workspace", "window"].includes(event.type))
                root.eventCount++;
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        active: persist.init

        sourceComponent: RowLayout {
            anchors.fill: parent
            spacing: 0

            Repeater {
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

                    color: {
                        if (mouseArea.containsMouse || (workspaceExists && workspace.focused))
                            return Colors.base02;
                        return Colors.base01;
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onPressed: I3.dispatch(`workspace number ${unit.name}`)
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            opacity: mouseArea.containsMouse || (unit.workspaceExists && unit.workspace.focused) ? 1 : 0
                            color: {
                                if (unit.workspaceExists && unit.workspace.focused)
                                    return Colors.base09;
                                return Colors.base0A;
                            }

                            Layout.fillWidth: true
                            Layout.preferredHeight: 3
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                anchors.centerIn: parent

                                text: unit.name
                                color: {
                                    if (unit.workspaceExists && unit.workspace.focused)
                                        return Colors.base09;
                                    if (mouseArea.containsMouse)
                                        return Colors.base0A;
                                    if (unit.workspaceExists)
                                        return Colors.base07;
                                    return Colors.base03;
                                }
                                font.pixelSize: 16
                            }
                        }
                    }
                }
            }
        }
    }
}
