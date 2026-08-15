import QtQuick
import qs.services
import qs.modules

BaseText {
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
