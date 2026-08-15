//@ pragma env QS_NO_RELOAD_POPUP

import QtQuick
import Quickshell
import qs.services
import qs.modules as Modules

ShellRoot {
    Component.onCompleted: Backlight.brightness
    Modules.Bar {}
    Modules.Launcher {}
}
