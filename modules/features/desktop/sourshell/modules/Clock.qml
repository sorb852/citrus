import QtQuick
import Quickshell
import qs.services

Rectangle {
    implicitWidth: clock.width
    color: Colors.base09

    SystemClock {
        id: systemtime
        precision: SystemClock.Minutes
    }

    BaseText {
        id: clock
        leftPadding: 10
        rightPadding: 10
        anchors.verticalCenter: parent.verticalCenter

        font.bold: true
        color: Colors.base01
        text: Qt.formatDateTime(systemtime.date, "hh:mm MM/dd")
    }
}
