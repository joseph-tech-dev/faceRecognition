import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 6.2  // ✅ Correct for Qt 6+

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720
    property StackView stackView

    // Custom properties for theming
    property color neonBlue: "#00f2ff"
    property color neonBlueDark: "#006a71"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color textColor: "#ffffff"
    property real borderWidth: 0.5
    property real globalMargin: 15  // Added global margin constant
    property real panelSpacing: 20  // Added spacing between panels

    //property for image replace
    property url selectedImagePath: "qrc:/assets/Face_placeholder.jpeg"



    // Background
    Rectangle {
        id: background
        anchors.fill: parent
        color: bgColor

        // Subtle grid pattern
        Canvas {
            anchors.fill: parent
            opacity: 0.05
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

    // Main layout with outer margins
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: globalMargin  // Added outer margin
        spacing: panelSpacing  // Added spacing between header and content

        // Top Header Bar
        Rectangle {
            id: header
            Layout.fillWidth: true
            height: root.height * 0.1
            color: "transparent"
            border.color: neonBlue
            border.width: borderWidth
            radius: 4

            // Inner glow effect using a lighter border
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                color: "transparent"
                border.color: Qt.lighter(neonBlue, 1.5)
                border.width: 1
                radius: parent.radius - 2
                opacity: 0.7
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: root.width * 0.02

                // System name
                Text {
                    text: "ZEPHIX"
                    color: neonBlue
                    font {
                        pixelSize: root.width * 0.022
                        family: "Courier New"
                        weight: Font.Bold
                        letterSpacing: 2
                    }
                    Layout.alignment: Qt.AlignLeft
                }

                Item { Layout.fillWidth: true }

                // Status indicator
                Row {
                    spacing: 10
                    layoutDirection: Qt.RightToLeft

                    // Clock
                    Text {
                        id: clock
                        text: Qt.formatTime(new Date(), "hh:mm")
                        color: neonBlue
                        font {
                            pixelSize: root.width * 0.016
                            family: "Courier New"
                            weight: Font.Bold
                        }

                        // Update clock every minute
                        Timer {
                            interval: 60000
                            running: true
                            repeat: true
                            onTriggered: clock.text = Qt.formatTime(new Date(), "hh:mm")
                        }
                    }

                    // Status indicator with pulsing animation
                    Rectangle {
                        id: statusIndicator
                        width: 10
                        height: 10
                        radius: 5
                        color: neonBlue
                        anchors.verticalCenter: parent.verticalCenter

                        // Pulsing animation
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.3; duration: 800 }
                            NumberAnimation { to: 1.0; duration: 800 }
                        }
                    }

                    Text {
                        text: "ONLINE"
                        color: "#00ffaa"
                        font {
                            pixelSize: root.width * 0.014
                            family: "Courier New"
                            weight: Font.Bold
                        }
                    }

                    Text {
                        text: "SYSTEM STATUS"
                        color: neonBlue
                        font {
                            pixelSize: root.width * 0.014
                            family: "Courier New"
                            weight: Font.Bold
                        }
                    }
                }
            }
        }

        // Main content area with spacing
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: panelSpacing * 1.5  // Increased spacing between panels
            anchors.margins: globalMargin / 2

            // Side Navigation Menu
            Rectangle {
                id: sidebar
                Layout.preferredWidth: root.width * 0.15
                Layout.fillHeight: true
                color: panelColor
                border.color: neonBlue
                border.width: borderWidth
                radius: 8

                // Inner padding for sidebar
                anchors.margins: globalMargin / 2

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

                Column {
                    anchors.centerIn: parent
                    spacing: root.height * 0.05
                    width: parent.width * 0.9

                    Repeater {
                        model: ["HOME", "SCAN", "DATABASE", "SETTINGS", "OSINT"]
                        delegate: Rectangle {
                            width: parent.width
                            height: root.height * 0.06
                            color: modelData === "SCAN" ? Qt.rgba(0, 0.95, 1, 0.1) : "transparent"
                            border.color: modelData === "SCAN" ? neonBlue : "transparent"
                            border.width: 1
                            radius: 4

                            // Inner highlight for selected item
                            Rectangle {
                                visible: modelData === "SCAN"
                                anchors.fill: parent
                                anchors.margins: 2
                                color: "transparent"
                                border.color: Qt.lighter(neonBlue, 1.5)
                                border.width: 1
                                radius: parent.radius - 2
                                opacity: 0.7
                            }

                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.014
                                    family: "Courier New"
                                    weight: Font.Bold
                                    letterSpacing: 1
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.border.color = neonBlue
                                onExited: if (modelData !== "SCAN") parent.border.color = "transparent"
                                onClicked: {
                                    console.log(modelData + " clicked");

                                    // Navigation logic
                                    if (modelData === "HOME") {
                                        // Navigate to Dashboard.qml
                                        stackView.push("Dashboard.qml"); // If using StackView
                                    }
                                    else if (modelData === "SCAN") {
                                        // Navigate to FaceScan.qml
                                        stackView.push("FaceScan.qml"); // If using StackView
                                    }
                                    else if (modelData === "DATABASE") {
                                        // Navigate to Database.qml
                                        stackView.push("Database.qml");
                                    }
                                    else if (modelData === "OSINT") {
                                        stackView.push("OSINTLookup.qml")

                                    }
                                    else if (modelData === "SETTINGS") {
                                        // Navigate to Settings.qml
                                        stackView.push("Settings.qml");
                                    }
                                }
                            }
                        }
                    }
                }
            }
            FileDialog {
                id: fileDialog
                title: "Select Face Image"
                nameFilters: ["*.jpg", "*.jpeg", "*.png"]
                currentFolder: StandardPaths.pictures
                onAccepted: {
                    if (fileDialog.selectedFile !== "") {
                        selectedImagePath = fileDialog.selectedFile
                        console.log("Image set to:", selectedImagePath)

                        var localPath = selectedImagePath.toString().replace("file://", "")
                        console.log("Passing to C++:", localPath)

                        faceScanManager.scanImage(localPath)
                    } else {
                        console.log("No file selected.")
                    }
                }
                onRejected: {
                    console.log("Dialog cancelled")
                }
            }







            // Scan Area with padding
            Rectangle {
                id: scanArea
                Layout.preferredWidth: root.width * 0.5
                Layout.fillHeight: true
                color: panelColor
                border.color: neonBlue
                border.width: borderWidth
                radius: 8

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

                Column {
                    anchors.fill: parent
                    anchors.margins: root.width * 0.03  // Increased inner margins
                    spacing: root.height * 0.05

                    // Face frame with animated border
                    Rectangle {
                        id: faceFrame
                        width: parent.width * 0.9
                        height: parent.height * 0.7
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#111"
                        border.color: neonBlue
                        border.width: 2
                        radius: 8

                        // Added margin around face frame
                        anchors.topMargin: root.height * 0.02

                        // Animated border effect
                        Rectangle {
                            id: pulseBorder
                            anchors.fill: parent
                            anchors.margins: -2
                            radius: parent.radius + 2
                            color: "transparent"
                            border.color: neonBlue
                            border.width: 2
                            opacity: 0.7

                            SequentialAnimation on border.width {
                                loops: Animation.Infinite
                                NumberAnimation { to: 6; duration: 1500; easing.type: Easing.InOutQuad }
                                NumberAnimation { to: 2; duration: 1500; easing.type: Easing.InOutQuad }
                            }

                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.3; duration: 1500; easing.type: Easing.InOutQuad }
                                NumberAnimation { to: 0.7; duration: 1500; easing.type: Easing.InOutQuad }
                            }
                        }

                        // Placeholder image
                        Image {
                            anchors.fill: parent
                            anchors.margins: 15
                            source: selectedImagePath
                            fillMode: Image.PreserveAspectFit
                        }

                    }

                    // Scan button with padding
                    Rectangle {
                        id: scanButton
                        width: parent.width * 0.6
                        height: root.height * 0.08
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "transparent"
                        border.color: neonBlue
                        border.width: 2
                        radius: height/2

                        // Added margin above button
                        anchors.topMargin: root.height * 0.03

                        // Inner glow
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2
                            color: "transparent"
                            border.color: Qt.lighter(neonBlue, 1.5)
                            border.width: 1
                            radius: parent.radius - 2
                            opacity: 0.7
                        }

                        Text {
                            text: "SCAN"
                            anchors.centerIn: parent
                            color: neonBlue
                            font {
                                pixelSize: root.width * 0.018
                                family: "Courier New"
                                weight: Font.Bold
                                letterSpacing: 2
                            }
                        }

                        // Button effects
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                scanButton.color = Qt.rgba(0, 0.95, 1, 0.1)
                                scanButton.border.width = 3
                            }
                            onExited: {
                                scanButton.color = "transparent"
                                scanButton.border.width = 2
                            }
                            onClicked: {
                                fileDialog.open()
                            }

                        }
                    }
                }
            }

            // Match Result Panel with padding
            Rectangle {
                id: resultPanel
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: panelColor
                border.color: neonBlue
                border.width: borderWidth
                radius: 8

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

                Column {
                    anchors.fill: parent
                    anchors.margins: root.width * 0.04  // Increased inner margins
                    spacing: root.height * 0.03  // Increased spacing between elements

                    // Match Result header
                    Text {
                        text: "MATCH RESULT"
                        color: neonBlue
                        font {
                            pixelSize: root.width * 0.018
                            family: "Courier New"
                            weight: Font.Bold
                            letterSpacing: 1
                        }

                        // Added margin below header
                        anchors.leftMargin: root.width * 0.01
                        anchors.topMargin: root.height * 0.02
                    }

                    // Divider line
                    Rectangle {
                        width: parent.width * 0.95  // Slightly shorter line
                        height: 1
                        color: neonBlue
                        opacity: 0.5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // Result details with spacing
                    Column {
                        width: parent.width
                        spacing: root.height * 0.025  // Increased spacing between sections
                        anchors.topMargin: root.height * 0.02

                        // Name section
                        Column {
                            width: parent.width
                            spacing: 4  // Increased spacing between elements

                            Text {
                                text: "NAME"
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.012
                                    family: "Courier New"
                                    weight: Font.Bold
                                }
                                opacity: 0.7
                            }

                            Text {
                                text: "JOHN DOE"
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.016
                                    family: "Courier New"
                                    weight: Font.Bold
                                }
                            }

                            Rectangle {
                                width: parent.width * 0.9
                                height: 1
                                color: neonBlue
                                opacity: 0.2
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // ID section
                        Column {
                            width: parent.width
                            spacing: 4

                            Text {
                                text: "ID"
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.012
                                    family: "Courier New"
                                    weight: Font.Bold
                                }
                                opacity: 0.7
                            }

                            Text {
                                text: "A53207"
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.016
                                    family: "Courier New"
                                    weight: Font.Bold
                                }
                            }

                            Rectangle {
                                width: parent.width * 0.9
                                height: 1
                                color: neonBlue
                                opacity: 0.2
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        // Score section
                        Column {
                            width: parent.width
                            spacing: 4

                            Text {
                                text: "SCORE"
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.012
                                    family: "Courier New"
                                    weight: Font.Bold
                                }
                                opacity: 0.7
                            }

                            Text {
                                text: "98%"
                                color: neonBlue
                                font {
                                    pixelSize: root.width * 0.016
                                    family: "Courier New"
                                    weight: Font.Bold
                                }
                            }

                            Rectangle {
                                width: parent.width * 0.9
                                height: 1
                                color: neonBlue
                                opacity: 0.2
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
