import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600
    property StackView stackView

    // Custom properties matching FACEINTEL theme
    property color neonBlue: "#00f2ff"
    property color neonBlueDark: "#006a71"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color textColor: "#ffffff"
    property real borderWidth: 1.5
    property real globalMargin: 15

    // Background with space texture
    Rectangle {
        id: background
        anchors.fill: parent
        color: bgColor

        // Subtle grid pattern
        Canvas {
            anchors.fill: parent
            opacity: 0.09
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = neonBlue
                ctx.lineWidth = 1

                // Vertical lines
                for (var x = 0; x < width; x += 30) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }

                // Horizontal lines
                for (var y = 0; y < height; y += 30) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }
        }
    }

    // Outer glow effect for login box
    Rectangle {
        width: 420
        height: 320
        radius: 25
        color: neonBlue
        opacity: 0.15
        anchors.centerIn: parent

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.25; duration: 2000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 0.15; duration: 2000; easing.type: Easing.InOutQuad }
        }
    }

    // Login box
    Rectangle {
        id: loginBox
        width: 400
        height: 300
        anchors.centerIn: parent
        radius: 20
        color: panelColor
        border.color: neonBlue
        border.width: borderWidth

        // Inner glow
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
            spacing: 25

            // Login title with glow effect
            Text {
                text: "FACEINTEL LOGIN"
                color: neonBlue
                font {
                    pixelSize: 28
                    family: "Courier New"
                    weight: Font.Bold
                    letterSpacing: 2
                }
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true

                Rectangle {
                    width: parent.width * 0.6
                    height: 1
                    color: neonBlue
                    opacity: 0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                    anchors.topMargin: 5
                }
            }

            // Username input
            Rectangle {
                width: 280
                height: 45
                radius: 8
                color: Qt.darker(panelColor, 1.2)
                border.color: neonBlue
                border.width: 1

                // Inner glow
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
                    spacing: 10
                    anchors.leftMargin: 10

                    Image {
                        source: "qrc:/assets/icons/user.png"
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignVCenter
                       // color: neonBlue
                    }

                    TextField {
                        id: usernameInput
                        placeholderText: "USERNAME"
                        placeholderTextColor: Qt.lighter(neonBlue, 1.5)
                        color: neonBlue
                        font {
                            pixelSize: 16
                            family: "Courier New"
                            weight: Font.Bold
                            capitalization: Font.AllUppercase
                        }
                        background: Rectangle { color: "transparent" }
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                        Layout.rightMargin: 10
                    }
                }
            }

            // Password input
            Rectangle {
                width: 280
                height: 45
                radius: 8
                color: Qt.darker(panelColor, 1.2)
                border.color: neonBlue
                border.width: 1

                // Inner glow
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
                    spacing: 10
                    anchors.leftMargin: 10

                    Image {
                        source: "qrc:/assets/icons/lock.png"
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignVCenter
                        //color: neonBlue
                    }

                    TextField {
                        id: passwordInput
                        placeholderText: "PASSWORD"
                        placeholderTextColor: Qt.lighter(neonBlue, 1.5)
                        echoMode: TextInput.Password
                        color: neonBlue
                        font {
                            pixelSize: 16
                            family: "Courier New"
                            weight: Font.Bold
                            capitalization: Font.AllUppercase
                        }
                        background: Rectangle { color: "transparent" }
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                        Layout.rightMargin: 10
                    }
                }
            }

            // Login button with glow effect
            Rectangle {
                id: loginButton
                width: 200
                height: 50
                radius: 8
                color: "transparent"
                border.color: neonBlue
                border.width: 2
                Layout.alignment: Qt.AlignHCenter

                // Inner glow
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
                    font {
                        pixelSize: 18
                        family: "Courier New"
                        weight: Font.Bold
                        letterSpacing: 1
                    }
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
                        if (usernameInput.text === "admin" && passwordInput.text === "1234") {
                            console.log("Login successful")
                            stackView.push("qrc:/qml/Dashboard.qml")
                        } else {
                            console.log("Invalid credentials")
                            // Add error animation
                            errorAnimation.start()
                        }
                    }
                }

                SequentialAnimation {
                    id: errorAnimation
                    loops: 2
                    PropertyAnimation {
                        target: loginButton
                        property: "x"
                        from: loginButton.x
                        to: loginButton.x - 5
                        duration: 50
                    }
                    PropertyAnimation {
                        target: loginButton
                        property: "x"
                        from: loginButton.x - 5
                        to: loginButton.x + 5
                        duration: 100
                    }
                    PropertyAnimation {
                        target: loginButton
                        property: "x"
                        from: loginButton.x + 5
                        to: loginButton.x
                        duration: 50
                    }
                }
            }
        }
    }

    // Animated particles matching FACEINTEL theme
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
                NumberAnimation {
                    from: opacity;
                    to: opacity * 0.5;
                    duration: 1000 + Math.random() * 2000
                }
                NumberAnimation {
                    from: opacity * 0.5;
                    to: opacity;
                    duration: 1000 + Math.random() * 2000
                }
            }

            PropertyAnimation on x {
                from: -width
                to: parent.width + width
                duration: 10000 + Math.random() * 20000
                loops: Animation.Infinite
            }
        }
    }
}
