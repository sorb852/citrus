import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    focusable: true

    WlrLayershell.layer: WlrLayer.Top
    implicitHeight: 24
    color: Colors.base01

    FileView {
        id: termPrefixFile
        path: Quickshell.env("SOURSHELL_LAUNCHER_TERMINAL_PREFIX")
        blockLoading: true
    }

    ScriptModel {
        id: filtered
        values: {
            const initial = DesktopEntries.applications.values;
            const filtered = initial.filter(d => !d.noDisplay && d.name.toLowerCase().includes(input.text.toLowerCase()));
            const sorted = filtered.sort();
            return sorted;
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 8

        Rectangle {
            id: prompt
            Layout.fillHeight: true
            Layout.preferredWidth: promptText.width
            color: Colors.base09

            BaseText {
                id: promptText
                anchors.centerIn: parent
                leftPadding: 8
                rightPadding: 8

                text: "[RUN]"
                font.bold: true
                font.pixelSize: 16
                color: Colors.base01
            }
        }

        TextInput {
            id: input
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 300
            focus: true
            clip: true
            cursorVisible: true

            color: Colors.base07
            font.pixelSize: 16
            font.family: "Hurmit Nerd Font"

            onAccepted: {
                const selectedItem = list.currentItem;
                if (selectedItem === null) {
                    console.warn("No application selected");
                    return;
                }

                const selected = selectedItem.modelData;
                const termPrefix = selected.runInTerminal ? JSON.parse(termPrefixFile.text() || '{"prefix":[]}').prefix : [];
                const command = [...termPrefix, ...selected.command];

                console.log(`Running "${command.join(' ')}"`);
                Quickshell.execDetached({
                    command,
                    workingDirectory: selected.workingDirectory
                });
            }

            Shortcut {
                sequence: "Escape"
                onActivated: input.clear()
            }

            Shortcut {
                sequences: ["Ctrl+N"]
                onActivated: list.incrementCurrentIndex()
            }

            Shortcut {
                sequences: ["Ctrl+P"]
                onActivated: list.decrementCurrentIndex()
            }
        }

        ListView {
            id: list
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 8

            orientation: Qt.Horizontal

            highlight: Rectangle {
                color: Colors.base09
            }
            highlightMoveDuration: 0
            highlightResizeDuration: 0

            model: filtered.values

            delegate: BaseText {
                required property var modelData
                property bool isHighlighted: modelData.id === (list.currentItem === null ? null : list.currentItem.modelData.id)

                leftPadding: 8
                rightPadding: 8

                text: modelData.name
                font.bold: true
                color: isHighlighted ? Colors.base01 : Colors.base07
            }
        }
    }
}
