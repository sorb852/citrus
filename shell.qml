import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.UPower
import qs.services
import qs.modules as Modules

ShellRoot {
    PanelWindow {
        anchors {
            left: true
            right: true
            bottom: true
        }
        WlrLayershell.layer: WlrLayer.Top
        implicitHeight: 32
        color: Colors.base01

        Modules.Clock {
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

            Modules.BaseText {
                id: cpuUsage

                color: {
                    if (SysInfo.cpuUsage > 0.8)
                        return Colors.base09;
                    if (SysInfo.cpuUsage > 0.6)
                        return Colors.base08;
                    if (SysInfo.cpuUsage > 0.25)
                        return Colors.base07;
                    return Colors.base0C;
                }
                text: `c[${Math.round(SysInfo.cpuUsage * 100)}%]`
            }

            Seperator {}

            Modules.BaseText {
                property real prettyPercentage: Math.round(UPower.displayDevice.percentage * 100)
                property string marker: {
                    if (UPower.displayDevice.changeRate > 0)
                        return '^';

                    if (UPower.displayDevice.percentage < 0.3)
                        return '!';
                    else
                        return '';
                }

                color: {
                    if (UPower.displayDevice.changeRate > 0)
                        return Colors.base0B;
                    const percentage = UPower.displayDevice.percentage;
                    if (percentage > 0.3)
                        return Colors.base07;
                    if (percentage > 0.1)
                        return Colors.base09;
                    return Colors.base08;
                }

                text: `b[${prettyPercentage}%${marker}]`
            }
        }
    }

    component Seperator: Rectangle {
        implicitWidth: 1
        implicitHeight: parent.height * 0.4
        color: Colors.base03
    }
}
