import QtQuick
import Quickshell.Services.UPower
import qs.services

BaseText {
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
