import QtQuick
import QtQuick.Layouts 6.3
import QtQuick.Controls 6.3

Window {
    id: window
    width: Screen.width
    height: Screen.height
    visibility: Qt.WindowFullScreen
    visible: true
    flags: Qt.FramelessWindowHint
    color: Style.window.background

    property var sessionList
    property bool thereAreSessions: false
    property bool includeUsername: false
    property string errorMsg

    signal newSession()
    signal openSession(int id)
    signal cancelOpenSession()
    signal passwordEntered(string username, string password)

    function setSessionList(list) {
        sessionList = []
        for (var id in list) {
            sessionList.push({"name": list[id], "id": id})
        }
        thereAreSessions = sessionList.length !== 0
    }

    function passwordRequested(_includeUsername) {
        includeUsername = _includeUsername
        stackView.push(pagePassword)
    }

    function showError(_errorMsg) {
        errorMsg = _errorMsg
        stackView.push(pageError)
    }

    Image {
        anchors.fill: parent
        source: "file:" + Style.window.backgroundImage
    }

    MouseArea {
        anchors.fill: parent
    }

    StackView {
        id: stackView
        font.pointSize: stackView.width * 0.01 <= 15 ? 15 : stackView.width * 0.01
        font.family: Style.text.fontFamily
        anchors.fill: parent
        initialItem: pageHome

        pushEnter: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 700 }
                XAnimator { from: stackView.width; to: 0; duration: 1200; easing.type: Easing.OutCubic }
            }
        }

        pushExit: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 700 }
                XAnimator { from: 0; to: -stackView.width; duration: 1200; easing.type: Easing.OutCubic }
            }
        }

        popEnter: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 700 }
                XAnimator { from: -stackView.width; to: 0; duration: 1200; easing.type: Easing.OutCubic }
            }
        }

        popExit: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 700 }
                XAnimator { from: 0; to: stackView.width; duration: 1200; easing.type: Easing.OutCubic }
            }
        }

        Component {
            id: pageHome

            ColumnLayout {
                anchors.left: stackView.left
                anchors.right: stackView.right
                anchors.top: stackView.top
                anchors.bottom: stackView.bottom
                anchors.topMargin: stackView.height * 0.3
                anchors.bottomMargin: stackView.height * 0.4
                spacing: stackView.height * 0.05

                Button {
                    text: qsTr("New Session")
                    Layout.preferredWidth: stackView.width * 0.35
                    Layout.preferredHeight: stackView.height * 0.15
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    background: Rectangle {
                        color: parent.hovered ? Style.mainButton.hoverColor : Style.mainButton.normalColor
                        border.color: Style.mainButton.borderColor
                        border.width: Style.mainButton.borderWidth
                        radius: Style.mainButton.radius
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pointSize: stackView.font.pointSize
                        font.bold: Style.mainButton.fontBold
                        color: Style.mainButton.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: newSession()
                }

                Button {
                    text: qsTr("Existing Sessions")
                    visible: thereAreSessions
                    Layout.preferredWidth: stackView.width * 0.35
                    Layout.preferredHeight: stackView.height * 0.15
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    background: Rectangle {
                        color: parent.hovered ? Style.secondaryButton.hoverColor : Style.secondaryButton.normalColor
                        border.color: Style.secondaryButton.borderColor
                        border.width: Style.secondaryButton.borderWidth
                        radius: Style.secondaryButton.radius
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pointSize: stackView.font.pointSize
                        font.bold: Style.secondaryButton.fontBold
                        color: Style.secondaryButton.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: stackView.push(pageSessions)
                }
            }
        }

        Component {
            id: pageSessions

            ColumnLayout {
                anchors.left: stackView.left
                anchors.right: stackView.right
                anchors.top: stackView.top
                anchors.bottom: stackView.bottom
                anchors.topMargin: stackView.height * 0.15
                anchors.bottomMargin: stackView.height * 0.15
                spacing: stackView.height * 0.03

                Text {
                    text: qsTr("Existing Sessions")
                    font.pointSize: stackView.font.pointSize
                    font.bold: Style.text.bold
                    color: Style.text.color
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.leftMargin: stackView.width * 0.25
                }

                ScrollView {
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    Layout.preferredWidth: stackView.width * 0.5
                    Layout.minimumHeight: stackView.height * 0.15
                    Layout.maximumHeight: stackView.height * 0.6
                    Layout.leftMargin: stackView.width * 0.25
                    ScrollBar.vertical.contentItem : Rectangle {
                        color: Style.scrollBar.color
                        implicitWidth: 6
                        radius: Style.scrollBar.radius
                    }

                    ListView {
                        model: sessionList
                        spacing: stackView.height * 0.03
                        delegate:
                            Button {
                            text: qsTr(sessionList[index].name)
                            width: stackView.width * 0.45
                            height: stackView.height * 0.12
                            background: Rectangle {
                                color: parent.hovered ? Style.mainButton.hoverColor : Style.mainButton.normalColor
                                border.color: Style.mainButton.borderColor
                                border.width: Style.mainButton.borderWidth
                                radius: Style.mainButton.radius
                            }
                            contentItem: Text {
                                text: parent.text
                                font.pointSize: stackView.font.pointSize
                                font.bold: Style.mainButton.fontBold
                                color: Style.mainButton.textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: openSession(sessionList[index].id)
                        }
                    }
                }

                Button {
                    text: qsTr("Cancel")
                    Layout.preferredWidth: stackView.width * 0.15
                    Layout.preferredHeight: stackView.height * 0.06
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.leftMargin: stackView.width * 0.25
                    background: Rectangle {
                        color: parent.hovered ? Style.cancelButton.hoverColor : Style.cancelButton.normalColor
                        border.color: Style.cancelButton.borderColor
                        border.width: Style.cancelButton.borderWidth
                        radius: Style.cancelButton.radius
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pointSize: stackView.font.pointSize
                        font.bold: Style.cancelButton.fontBold
                        color: Style.cancelButton.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: stackView.pop()
                }
            }
        }

        Component {
            id: pagePassword

            GridLayout {
                rows: 4
                columns: 2
                rowSpacing: stackView.height * 0.01
                columnSpacing: stackView.width * 0.01
                anchors.left: stackView.left
                anchors.right: stackView.right
                anchors.top: stackView.top
                anchors.bottom: stackView.bottom
                anchors.topMargin: stackView.height * 0.4
                anchors.bottomMargin: stackView.height * 0.5
                Keys.onEnterPressed: submitBtn.clicked()
                Keys.onReturnPressed: submitBtn.clicked()

                Text {
                    text: qsTr("Username")
                    font.pointSize: stackView.font.pointSize
                    font.bold: Style.text.bold
                    color: Style.text.color
                    visible: includeUsername
                    Layout.leftMargin: stackView.width * 0.3
                }

                TextField {
                    id: username
                    visible: includeUsername
                    color: Style.textField.textColor
                    font.bold: Style.textField.fontBold
                    background: Rectangle {
                        color: Style.textField.backgroundColor
                        border.width: Style.textField.borderWidth
                        radius: Style.textField.radius
                    }
                    Layout.fillWidth: true
                    Layout.rightMargin: stackView.width * 0.3
                }

                Text {
                    text: qsTr("Password")
                    font.pointSize: stackView.font.pointSize
                    font.bold: Style.text.bold
                    color: Style.text.color
                    Layout.leftMargin: stackView.width * 0.3
                }

                TextField {
                    id: password
                    echoMode: TextInput.Password
                    color: Style.textField.textColor
                    font.bold: Style.textField.fontBold
                    background: Rectangle {
                        color: Style.textField.backgroundColor
                        border.width: Style.textField.borderWidth
                        radius: Style.textField.radius
                    }
                    Layout.fillWidth: true
                    Layout.rightMargin: stackView.width * 0.3
                }

                Item {
                    Layout.leftMargin: stackView.width * 0.3
                }

                RowLayout {
                    spacing: stackView.width * 0.01
                    Layout.rightMargin: stackView.width * 0.3

                    Button {
                        id: submitBtn
                        text: qsTr("Ok")
                        Layout.fillWidth: true
                        Layout.preferredHeight: stackView.height * 0.05
                        background: Rectangle {
                            color: parent.hovered ? Style.okButton.hoverColor : Style.okButton.normalColor
                            border.color: Style.okButton.borderColor
                            border.width: Style.okButton.borderWidth
                            radius: Style.okButton.radius
                        }
                        contentItem: Text {
                            text: parent.text
                            font.pointSize: stackView.font.pointSize
                            font.bold: Style.okButton.fontBold
                            color: Style.okButton.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            if (!password.text || username.visible && !username.text)
                                passwordWarning.visible = true
                            else
                                passwordEntered(username.text, password.text)
                        }
                    }

                    Button {
                        text: qsTr("Cancel")
                        Layout.fillWidth: true
                        Layout.preferredHeight: stackView.height * 0.05
                        background: Rectangle {
                            color: parent.hovered ? Style.cancelButton.hoverColor : Style.cancelButton.normalColor
                            border.color: Style.cancelButton.borderColor
                            border.width: Style.cancelButton.borderWidth
                            radius: Style.cancelButton.radius
                        }
                        contentItem: Text {
                            text: parent.text
                            font.pointSize: stackView.font.pointSize
                            font.bold: Style.cancelButton.fontBold
                            color: Style.cancelButton.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            cancelOpenSession()
                            stackView.pop()
                        }
                    }
                }

                Item {
                    Layout.leftMargin: stackView.width * 0.3
                }

                Text {
                    id: passwordWarning
                    text: qsTr("Insert a valid password/username")
                    font.pointSize: stackView.font.pointSize
                    font.bold: Style.warningText.bold
                    color: Style.warningText.color
                    visible: false
                    Layout.rightMargin: stackView.width * 0.3
                    horizontalAlignment: Text.AlignRight
                }
            }
        }

        Component {
            id: pageError

            ColumnLayout {
                anchors.left: stackView.left
                anchors.right: stackView.right
                anchors.top: stackView.top
                anchors.bottom: stackView.bottom

                Text {
                    text: qsTr(errorMsg)
                    font.pointSize: stackView.font.pointSize
                    font.bold: Style.text.bold
                    color: Style.text.color
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    horizontalAlignment: Text.AlignHCenter
                }

                Button {
                    text: qsTr("Ok")
                    Layout.preferredWidth: stackView.width * 0.12
                    Layout.preferredHeight: stackView.height * 0.05
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    background: Rectangle {
                        color: parent.hovered ? Style.okButton.hoverColor : Style.okButton.normalColor
                        border.color: Style.okButton.borderColor
                        border.width: Style.okButton.borderWidth
                        radius: Style.okButton.radius
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pointSize: stackView.font.pointSize
                        font.bold: Style.okButton.fontBold
                        color: Style.okButton.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: stackView.pop(null)
                }
            }
        }
    }
}
