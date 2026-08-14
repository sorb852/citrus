pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    FileView {
        id: colorsJson
        path: Quickshell.env("QS_COLORS")
        blockLoading: true
    }

    readonly property var rawJson: JSON.parse(colorsJson.text() || "{}")

    readonly property color base00: rawJson["base00"] || "#0e1014"
    readonly property color base01: rawJson["base01"] || "#282a2d"
    readonly property color base02: rawJson["base02"] || "#424547"
    readonly property color base03: rawJson["base03"] || "#5c5f60"
    readonly property color base04: rawJson["base04"] || "#77797a"
    readonly property color base05: rawJson["base05"] || "#919393"
    readonly property color base06: rawJson["base06"] || "#abaead"
    readonly property color base07: rawJson["base07"] || "#c5c8c6"
    readonly property color base08: rawJson["base08"] || "#ff700f"
    readonly property color base09: rawJson["base09"] || "#f9a824"
    readonly property color base0A: rawJson["base0A"] || "#fdd41d"
    readonly property color base0B: rawJson["base0B"] || "#ceff1f"
    readonly property color base0C: rawJson["base0C"] || "#1fff57"
    readonly property color base0D: rawJson["base0D"] || "#1fff75"
    readonly property color base0E: rawJson["base0E"] || "#d8466f"
    readonly property color base0F: rawJson["base0F"] || "#ea3458"
}
