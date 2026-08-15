//@ pragma env QS_NO_RELOAD_POPUP

import QtQuick
import Quickshell
import qs.services
import qs.modules as Modules

ShellRoot {
    Component.onCompleted: {
        console.log("Starting services");
        const _backlight = Backlight;
        const _audio = Audio;
        const _sysinfo = SysInfo;
        const _colors = Colors;
    }
    Modules.Bar {}
    Modules.Launcher {}
}
