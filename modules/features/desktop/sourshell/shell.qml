//@ pragma env QS_NO_RELOAD_POPUP

import QtQuick
import Quickshell
import qs.services
import qs.modules as Modules

ShellRoot {
    Loader {
        active: {
            console.log("Starting services");
            const _backlight = Backlight;
            const _audio = Audio;
            const _sysinfo = SysInfo;
            const _colors = Colors;
            return true;
        }
        sourceComponent: Item {
            // NOTE: Always remember
            // though srsly i should ask these guys for ideas this was kinda interesting
            // Modules.Flash {}
            Modules.Bar {}
            Modules.Launcher {}
        }
    }
}
