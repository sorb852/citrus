pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root
    property real volume: 0.3
    property bool muted: false

    onVolumeChanged: {
        Pipewire.defaultAudioSink.audio.volume = root.volume;
    }

    onMutedChanged: {
        Pipewire.defaultAudioSink.audio.muted = root.muted;
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    function _clamp(v: real): real {
        return Math.min(1, Math.max(0, v));
    }

    function setVolume(v: real) {
        volume = _clamp(v);
    }
    function adjust(v: real) {
        volume = _clamp(volume + v);
    }

    function setMute(v: bool) {
        muted = v;
    }

    IpcHandler {
        target: "audio"

        function get(): real {
            return root.volume * 100;
        }
        function set(v: real) {
            root.setVolume(v / 100);
        }
        function inc(v: real) {
            root.adjust(v / 100);
        }
        function dec(v: real) {
            root.adjust(-(v / 100));
        }

        function unmute() {
            root.setMute(false);
        }
        function mute() {
            root.setMute(true);
        }
        function toggle() {
            root.setMute(!root.muted);
        }
    }

    Component.onCompleted: console.log("Audio service up")
}
