import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600
    property StackView stackView

    // Background gradient
    Rectangle {
        anchors.fill: parent
        color: "#050B1F"
        z: -1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0A1B40" }
            GradientStop { position: 1.0; color: "#050B1F" }
        }
    }

    // Simulated glow shadow layer
    Rectangle {
        width: 420
        height: 320
        radius: 25
        color: "#30B3FF"
        opacity: 0.15
        anchors.centerIn: parent
        z: 0
    }

    // Login box
    Rectangle {
        id: loginBox
        width: 400
        height: 300
        anchors.centerIn: parent
        radius: 20
        color: "#0B1D42"
        border.color: "#30B3FF"
        border.width: 2
        z: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 25

            Text {
                text: "LOGIN"
                color: "#E0FFFF"
                font.pixelSize: 28
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            // Username input
            Rectangle {
                width: 280
                height: 45
                radius: 8
                color: "#1A325A"
                border.color: "#30B3FF"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    Image {
                        source: "qrc:/assets/icons/user.png"
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        Layout.leftMargin: 10
                        verticalAlignment: Qt.AlignVCenter
                    }

                    TextField {
                        id: usernameInput
                        placeholderText: "Username"
                        placeholderTextColor: "#99BBEE"
                        color: "#E0FFFF"
                        font.pixelSize: 16
                        background: Rectangle { color: "transparent" }
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                    }
                }
            }

            // Password input
            Rectangle {
                width: 280
                height: 45
                radius: 8
                color: "#1A325A"
                border.color: "#30B3FF"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    Image {
                        source: "qrc:/assets/icons/lock.png"
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        Layout.leftMargin: 10
                        verticalAlignment: Qt.AlignVCenter
                    }

                    TextField {
                        id: passwordInput
                        placeholderText: "Password"
                        placeholderTextColor: "#99BBEE"
                        echoMode: TextInput.Password
                        color: "#E0FFFF"
                        font.pixelSize: 16
                        background: Rectangle { color: "transparent" }
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                    }
                }
            }

            // Login button
            Button {
                text: "Sign In"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 50

                background: Rectangle {
                    color: "#0F3A6E"
                    radius: 8
                    border.color: "#30B3FF"
                    border.width: 2
                }

                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 18
                    color: "#E0FFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    if (usernameInput.text === "admin" && passwordInput.text === "1234") {
                        console.log("Login successful")
                        stackView.push("qrc:/qml/FaceScan.qml") // or DashboardPage.qml depending on flow
                    } else {
                        console.log("Invalid username or password")
                    }
                }
            }
        }
    }

    // Glowing animated particles
    Repeater {
        model: 1000
        delegate: Rectangle {
            x: Math.random() * parent.width
            y: Math.random() * parent.height
            width: 8
            height: 8
            radius: 4
            color: "#30B3FF"
            opacity: 0.3
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 0.3; to: 0.7; duration: 1000; easing.type: Easing.InOutQuad }
                NumberAnimation { from: 0.7; to: 0.3; duration: 1000; easing.type: Easing.InOutQuad }
            }
        }
    }
}
