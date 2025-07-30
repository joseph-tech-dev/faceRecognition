import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600
    property StackView stackView

    // Custom theme properties
    property color neonBlue: "#00f2ff"
    property color neonBlueDark: "#006a71"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color textColor: "#ffffff"
    property real borderWidth: 1.5
    property real globalMargin: 15

    // ====================== BACKGROUND ======================
    Rectangle {
        id: background
        anchors.fill: parent
        color: bgColor

        Canvas {
            anchors.fill: parent
            opacity: 0.09
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = neonBlue
                ctx.lineWidth = 1
                for (var x = 0; x < width; x += 30) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }
                for (var y = 0; y < height; y += 30) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }
        }
    }

    // ====================== GLOW BOX ======================
    Rectangle {
        width: 420
        height: 320
        radius: 25
        color: neonBlue
        opacity: 0.15
        anchors.centerIn: parent

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.25; duration: 2 }
            NumberAnimation { to: 0.15; duration: 2 }
        }
    }

    // ====================== LOGIN BOX ======================
    Rectangle {
        id: loginBox
        width: 400
        height: 360
        anchors.centerIn: parent
        radius: 20
        color: panelColor
        border.color: neonBlue
        border.width: borderWidth

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            color: "transparent"
            border.color: Qt.lighter(neonBlue, 1.5)
            border.width: 1
            radius: parent.radius - 2
            opacity: 0.5
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            // === Title ===
            Text {
                text: "ZEPHIX LOGIN"
                color: neonBlue
                font.pixelSize: 28
                font.family: "Courier New"
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            // === Username Field ===
            Rectangle {
                width: 280
                height: 45
                radius: 8
                color: Qt.darker(panelColor, 1.2)
                border.color: neonBlue
                border.width: 1

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    color: "transparent"
                    border.color: Qt.lighter(neonBlue, 1.5)
                    border.width: 1
                    radius: parent.radius - 2
                    opacity: 0.3
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    Image {
                        source: "qrc:/assets/icons/user.png"
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                    }

                    TextField {
                        id: usernameInput
                        placeholderText: "USERNAME"
                        placeholderTextColor: Qt.lighter(neonBlue, 1.5)
                        color: neonBlue
                        font.pixelSize: 16
                        font.family: "Courier New"
                        font.weight: Font.Bold
                        font.capitalization: Font.AllUppercase
                        background: Rectangle { color: "transparent" }
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                    }
                }
            }

            // === Password Field ===
            Rectangle {
                width: 280
                height: 45
                radius: 8
                color: Qt.darker(panelColor, 1.2)
                border.color: neonBlue
                border.width: 1

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    color: "transparent"
                    border.color: Qt.lighter(neonBlue, 1.5)
                    border.width: 1
                    radius: parent.radius - 2
                    opacity: 0.3
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    Image {
                        source: "qrc:/assets/icons/lock.png"
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                    }

                    TextField {
                        id: passwordInput
                        placeholderText: "PASSWORD"
                        echoMode: TextInput.Password
                        placeholderTextColor: Qt.lighter(neonBlue, 1.5)
                        color: neonBlue
                        font.pixelSize: 16
                        font.family: "Courier New"
                        font.weight: Font.Bold
                        font.capitalization: Font.AllUppercase
                        background: Rectangle { color: "transparent" }
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                    }
                }
            }

            // === Login Button ===
            Rectangle {
                id: loginButton
                width: 200
                height: 50
                radius: 8
                color: "transparent"
                border.color: neonBlue
                border.width: 2
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    color: "transparent"
                    border.color: Qt.lighter(neonBlue, 1.5)
                    border.width: 1
                    radius: parent.radius - 2
                    opacity: 0.5
                }

                Text {
                    text: "AUTHENTICATE"
                    anchors.centerIn: parent
                    color: neonBlue
                    font.pixelSize: 18
                    font.family: "Courier New"
                    font.weight: Font.Bold
                    //letterSpacing: 1
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        loginButton.color = Qt.rgba(0, 0.95, 1, 0.1)
                        loginButton.border.width = 3
                    }
                    onExited: {
                        loginButton.color = "transparent"
                        loginButton.border.width = 2
                    }
                    onClicked: {
                        authManager.login(usernameInput.text, passwordInput.text)
                    }
                }

                SequentialAnimation {
                    id: errorAnimation
                    loops: 2
                    PropertyAnimation { target: loginButton; property: "x"; from: loginButton.x; to: loginButton.x - 5; duration: 50 }
                    PropertyAnimation { target: loginButton; property: "x"; from: loginButton.x - 5; to: loginButton.x + 5; duration: 100 }
                    PropertyAnimation { target: loginButton; property: "x"; from: loginButton.x + 5; to: loginButton.x; duration: 50 }
                }
            }

            // === Error Label ===
            Text {
                id: errorLabel
                text: ""
                color: "red"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // === Animated background particles ===
    Repeater {
        model: 100
        delegate: Rectangle {
            x: Math.random() * parent.width
            y: Math.random() * parent.height
            width: 2 + Math.random() * 4
            height: width
            radius: width / 2
            color: neonBlue
            opacity: 0.1 + Math.random() * 0.3

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: opacity; to: opacity * 0.5; duration: 1000 + Math.random() * 2000 }
                NumberAnimation { from: opacity * 0.5; to: opacity; duration: 1000 + Math.random() * 2000 }
            }

            PropertyAnimation on x {
                from: -width
                to: parent.width + width
                duration: 10000 + Math.random() * 20000
                loops: Animation.Infinite
            }
        }
    }

    // === Signal connection to AuthManager ===
    Connections {
        target: authManager

        function onLoginSuccess() {
            stackView.push("qrc:/qml/Dashboard.qml")
        }

        function onLoginFailed(reason) {
            console.log("Login failed:", reason)
            errorLabel.text = reason
            errorAnimation.start()
        }
    }

}
