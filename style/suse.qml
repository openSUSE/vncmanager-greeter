import QtQuick

QtObject {
    property QtObject window: QtObject {
        property color background: "#0c322c"
        property url backgroundImage: "/usr/share/vncmanager-greeter/suse_background.png"
    }

    property QtObject text: QtObject {
        property string fontFamily: "Poppins"
        property bool bold: true
        property color color: "#ffffff"
    }

    property QtObject warningText: QtObject {
        property color color: "#90ebcd"
        property bool bold: false
    }

    property QtObject mainButton: QtObject {
        property color textColor: "#000000"
        property color normalColor: "#fe7c3f"
        property color hoverColor: "#ba5d32"
        property color borderColor: "#000000"
        property bool fontBold: false
        property int borderWidth: 0
        property int radius: 0
    }

    property QtObject secondaryButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#00000000"
        property color hoverColor: "#20000000"
        property color borderColor: "#30ba78"
        property bool fontBold: true
        property int borderWidth: 3
        property int radius: 0
    }

    property QtObject okButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#fe7c3f"
        property color hoverColor: "#ba5d32"
        property color borderColor: "#000000"
        property bool fontBold: true
        property int borderWidth: 0
        property int radius: 0
    }

    property QtObject cancelButton: QtObject {
        property color textColor: "#ffffff"
        property color normalColor: "#00000000"
        property color hoverColor: "#20000000"
        property color borderColor: "#30ba78"
        property bool fontBold: true
        property int borderWidth: 3
        property int radius: 0
    }

    property QtObject textField: QtObject {
        property color textColor: "#000000"
        property color backgroundColor: "#c2c7d5"
        property bool fontBold: false
        property int borderWidth: 0
        property int radius: 5
    }

    property QtObject scrollBar: QtObject {
        property color color: "#30ba78"
        property int radius: 5
    }
}
