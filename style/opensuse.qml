import QtQuick

QtObject {
    property QtObject window: QtObject {
        property color background: "#222222"
        property url backgroundImage: "/usr/share/vncmanager-greeter/opensuse_background.png"
    }

    property QtObject text: QtObject {
        property string fontFamily: "Roboto"
        property bool bold: true
        property color color: "#ffffff"
    }

    property QtObject warningText: QtObject {
        property color color: "#c9b75b"
        property bool bold: true
    }

    property QtObject mainButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#74ba24"
        property color hoverColor: "#487515"
        property color borderColor: "#000000"
        property bool fontBold: true
        property int borderWidth: 0
        property int radius: 100
    }

    property QtObject secondaryButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#74ba24"
        property color hoverColor: "#487515"
        property color borderColor: "#000000"
        property bool fontBold: true
        property int borderWidth: 0
        property int radius: 100
    }

    property QtObject okButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#74ba24"
        property color hoverColor: "#487515"
        property color borderColor: "#000000"
        property bool fontBold: true
        property int borderWidth: 0
        property int radius: 100
    }

    property QtObject cancelButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#0076a8"
        property color hoverColor: "#004663"
        property color borderColor: "#000000"
        property bool fontBold: true
        property int borderWidth: 0
        property int radius: 100
    }

    property QtObject textField: QtObject {
        property color textColor: "#000000"
        property color backgroundColor: "#c2c7d5"
        property bool fontBold: true
        property int borderWidth: 0
        property int radius: 10
    }

    property QtObject scrollBar: QtObject {
        property color color: "#74ba24"
        property int radius: 0
    }
}
