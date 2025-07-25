
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: 1280
    height: 700

    Rectangle {
        id: mainBackground
        anchors.fill: parent
        color: "#0A0F1C"


        // Sidebar
        Rectangle {
            id: sidebar
            width: 220
            height: parent.height
            color: "#0D1326"
            border.color: "#00FFFF"
            border.width: 0.5
            anchors.top: header.bottom
            radius: 5



            Column {
                anchors.centerIn: parent
                spacing: 20

                Repeater {
                    model: ["HOME", "SCAN", "DATABASE", "SETTINGS"]
                    delegate: Text {
                        text: modelData
                        font.pixelSize: 18
                        color: "#00FFFF"
                        font.family: "Monospace"
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }
                }
            }
        }

        // Header
        Rectangle {
            id: header
           // x: sidebar.width
            width: parent.width
            height: 60
            color: "transparent"
            border.color: "#00FFFF"
            border.width: 1
            radius: 5
            anchors.right: parent.right

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20

                Text {
                    text: "FACEINTEL SYSTEM"
                    color: "#00FFFF"
                    font.pixelSize: 22
                    font.bold: true
                    font.family: "Monospace"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "ONLINE"
                    color: "#00FFAA"
                    font.pixelSize: 16
                    font.family: "Monospace"
                }

                Text {
                    text: Qt.formatTime(new Date(), "hh:mm")
                    color: "#00FFFF"
                    font.pixelSize: 16
                    font.family: "Monospace"
                    padding: 10
                }
            }
        }

        // Camera View Area
        Rectangle {
            id: scanFrame
            x: sidebar.width + 40
            y: header.height + 30
            width: 400
            height: 500
            color: "#0F172A"
            border.color: "#00FFFF"
            border.width: 2
            radius: 12

            // Face placeholder
            Image {
                source: "assets/face_placeholder.png"
                anchors.centerIn: parent
                width: parent.width * 0.7
                height: parent.height * 0.7
                fillMode: Image.PreserveAspectFit
            }
        }

        // Match Results
        Rectangle {
            id: matchResult
            width: 350
            height: 300
            x: scanFrame.x + scanFrame.width + 40
            y: scanFrame.y + 40
            color: "#0F172A"
            border.color: "#00FFFF"
            border.width: 2
            radius: 12

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "MATCH RESULT"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#00FFFF"
                    font.family: "Monospace"
                }

                Column {
                    spacing: 10
                    Text { text: "Name:  JOHN DOE"; color: "#00FFFF"; font.pixelSize: 16 }
                    Text { text: "ID:    A53207"; color: "#00FFFF"; font.pixelSize: 16 }
                    Text { text: "Score: 98%"; color: "#00FFAA"; font.pixelSize: 16 }
                }
            }
        }

        // Scan Button
        Rectangle {
            id: scanButton
            width: 200
            height: 50
            x: scanFrame.x + 100
            y: scanFrame.y + scanFrame.height + 20
            color: "#00FFFF"
            radius: 10
            border.color: "#00FFFF"

            Text {
                anchors.centerIn: parent
                text: "SCAN"
                color: "#0A0F1C"
                font.pixelSize: 18
                font.bold: true
                font.family: "Monospace"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("Scan triggered")
                }
            }
        }
    }
}
