import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600
    property StackView stackView

    // Theme properties
    property color neonBlue: "#00f2ff"
    property color neonBlueDark: "#006a71"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color textColor: "#ffffff"
    property real borderWidth: 1.5
    property real globalMargin: 15

    // Background with space texture
    Rectangle {
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

    // Main content container
    Rectangle {
        anchors {
            fill: parent
            margins: globalMargin
        }
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            // Header bar
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: 20

                    // System title
                    Text {
                        text: "FACETNTELL.SYSTEM"
                        font {
                            family: "Courier New"
                            bold: true
                            pixelSize: 18
                            letterSpacing: 1
                        }
                        color: neonBlue
                    }

                    Item { Layout.fillWidth: true }

                    // Status indicator
                    StatusIndicator {
                        status: "ONLINE"
                        color: neonBlue
                    }

                    // Current time
                    Text {
                        text: Qt.formatTime(new Date(), "hh:mm")
                        font {
                            family: "Courier New"
                            pixelSize: 16
                        }
                        color: neonBlue
                    }
                }

                // Header separator
                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: neonBlue
                    opacity: 0.3
                }
            }

            // Navigation tabs
            TabBar {
                Layout.fillWidth: true
                height: 40
                background: Rectangle { color: "transparent" }
                currentIndex: 1

                Repeater {
                    model: ["HOME", "OSINT LOOKUP"]
                    TabButton {
                        text: modelData
                        font {
                            family: "Courier New"
                            pixelSize: 14
                        }
                        background: Rectangle {
                            color: index === 1 ? neonBlueDark : "transparent"
                            radius: 4
                        }
                        contentItem: Text {
                            text: modelData
                            color: index === 1 ? "white" : neonBlue
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font

                        }
                        onClicked: {
                            if (!stackView) {
                                console.warn("StackView not available")
                                return
                            }

                            var component = Qt.createComponent("qrc:/qml/Dashboard.qml")
                            if (component.status === Component.Ready) {
                                var dashboard = component.createObject(stackView, { stackView: stackView })
                                stackView.push(dashboard)
                            } else {
                                console.error("Failed to load Dashboard.qml:", component.errorString())
                            }

                        }
                    }
                }
            }

            // Main content area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    // Search section
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        // Search input
                        Rectangle {
                            Layout.fillWidth: true
                            height: 45
                            radius: 6
                            color: Qt.darker(panelColor, 1.1)
                            border.color: neonBlue
                            border.width: borderWidth

                            TextField {
                                anchors.fill: parent
                                anchors.margins: 10
                                placeholderText: "username or email or phone number"
                                placeholderTextColor: Qt.lighter(neonBlue, 1.3)
                                color: neonBlue
                                font {
                                    family: "Courier New"
                                    pixelSize: 14
                                }
                                background: Rectangle { color: "transparent" }
                            }
                        }

                        // Search button
                        Rectangle {
                            Layout.fillWidth: true
                            height: 45
                            radius: 6
                            color: "transparent"
                            border.color: neonBlue
                            border.width: borderWidth

                            Text {
                                text: "SEARCH"
                                anchors.centerIn: parent
                                color: neonBlue
                                font {
                                    family: "Courier New"
                                    bold: true
                                    pixelSize: 16
                                    letterSpacing: 1
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = Qt.rgba(0, 0.95, 1, 0.1)
                                onExited: parent.color = "transparent"
                                onClicked: performSearch()
                            }
                        }
                    }

                    // Results section
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 15

                            // Profile card
                            Rectangle {
                                Layout.fillWidth: true
                                height: 100
                                radius: 6
                                color: panelColor
                                border.color: neonBlue
                                border.width: borderWidth

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 15

                                    // Profile initials (JD)
                                    Text {
                                        text: "JD"
                                        font {
                                            family: "Courier New"
                                            bold: true
                                            pixelSize: 24
                                        }
                                        color: neonBlue
                                    }

                                    // Profile name and info
                                    ColumnLayout {
                                        spacing: 5

                                        Text {
                                            text: "John Doe"
                                            font {
                                                family: "Courier New"
                                                bold: true
                                                pixelSize: 18
                                            }
                                            color: textColor
                                        }

                                        Text {
                                            text: "Primary Target"
                                            font {
                                                family: "Courier New"
                                                pixelSize: 14
                                            }
                                            color: neonBlue
                                        }
                                    }

                                    Item { Layout.fillWidth: true }

                                    // View button
                                    Rectangle {
                                        width: 80
                                        height: 30
                                        radius: 4
                                        color: "transparent"
                                        border.color: neonBlue
                                        border.width: borderWidth

                                        Text {
                                            text: "VIEW"
                                            anchors.centerIn: parent
                                            color: neonBlue
                                            font {
                                                family: "Courier New"
                                                bold: true
                                                pixelSize: 14
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: parent.color = Qt.rgba(0, 0.95, 1, 0.1)
                                            onExited: parent.color = "transparent"
                                            onClicked: viewProfile()
                                        }
                                    }
                                }
                            }

                            // URL results with properly aligned OPEN buttons
                            Repeater {
                                model: [
                                    {
                                        url: "www.example.com/johndoe",
                                        desc1: "Lorem ipsum dolor sit amet.",
                                        desc2: "consectetur adipiscing elit."
                                    },
                                    {
                                        url: "www.example.com",
                                        desc1: "Lorem ipsum dolor sit amet.",
                                        desc2: "consectetur adipiscing elit."
                                    }
                                ]

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 90
                                    radius: 6
                                    color: panelColor
                                    border.color: neonBlue
                                    border.width: borderWidth

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 15
                                        spacing: 10

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 5

                                            // URL
                                            Text {
                                                text: modelData.url
                                                font {
                                                    family: "Courier New"
                                                    pixelSize: 14
                                                }
                                                color: neonBlue
                                            }

                                            // Description lines
                                            Text {
                                                text: modelData.desc1
                                                font {
                                                    family: "Courier New"
                                                    pixelSize: 12
                                                }
                                                color: textColor
                                            }

                                            Text {
                                                text: modelData.desc2
                                                font {
                                                    family: "Courier New"
                                                    pixelSize: 12
                                                }
                                                color: textColor
                                            }
                                        }

                                        // Open button - Now properly vertically centered
                                        Rectangle {
                                            width: 70
                                            height: 25
                                            radius: 4
                                            color: "transparent"
                                            border.color: neonBlue
                                            border.width: borderWidth
                                            //Layout.alignment: Qt.AlignVCenter
                                            anchors {
                                                right: parent.right
                                                verticalCenter: parent.verticalCenter
                                            }


                                            Text {
                                                text: "OPEN"
                                                anchors.centerIn: parent
                                                color: neonBlue
                                                font {
                                                    family: "Courier New"
                                                    bold: true
                                                    pixelSize: 12
                                                }
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                onEntered: parent.color = Qt.rgba(0, 0.95, 1, 0.1)
                                                onExited: parent.color = "transparent"
                                                onClicked: openUrl(modelData.url)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Footer
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: "transparent"

                Rectangle {
                    width: 100
                    height: 30
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    radius: 4
                    color: "transparent"
                    border.color: neonBlue
                    border.width: borderWidth

                    Text {
                        text: "SETTINGS"
                        anchors.centerIn: parent
                        color: neonBlue
                        font {
                            family: "Courier New"
                            pixelSize: 12
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Qt.rgba(0, 0.95, 1, 0.1)
                        onExited: parent.color = "transparent"
                        onClicked: openSettings()
                    }
                }
            }
        }
    }

    // Status indicator component
    component StatusIndicator : Text {
        property string status: "ONLINE"
        property color pcolor: neonBlue

        text: status
        font {
            family: "Courier New"
            pixelSize: 14
        }
        color: pcolor

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: parent.color
            anchors.right: parent.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Function stubs
    function performSearch() {
        console.log("Searching for:", searchField.text)
        // Implement search functionality
    }

    function viewProfile() {
        console.log("Viewing profile")
        // Implement profile viewing
    }

    function openUrl(url) {
        console.log("Opening URL:", url)
        // Implement URL opening
    }

    function openSettings() {
        console.log("Opening settings")
        // Implement settings opening
    }
}
