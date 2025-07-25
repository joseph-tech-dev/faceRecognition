import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Item {
    id: root
    width: Screen.width
    height: Screen.height

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#0A0F1C"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Top Bar
            Rectangle {
                Layout.fillWidth: true
                height: root.height * 0.08
                color: "transparent"
                border.color: "#00FFFF"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: root.width * 0.015

                    Text {
                        text: "FACEINTEL.SYSTEM"
                        color: "#00FFFF"
                        font.pixelSize: root.width * 0.018
                        Layout.alignment: Qt.AlignLeft
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "SYSTEM STATUS"
                        color: "#00FFFF"
                        font.pixelSize: root.width * 0.012
                    }

                    Text {
                        text: "ONLINE"
                        color: "#00FFAA"
                        font.pixelSize: root.width * 0.012
                        leftPadding: root.width * 0.008
                    }

                    Text {
                        text: Qt.formatTime(new Date(), "hh:mm")
                        color: "#00FFFF"
                        font.pixelSize: root.width * 0.014
                        leftPadding: root.width * 0.02
                    }
                }
            }

            // Main Section
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: root.width * 0.01

                // Sidebar
                Rectangle {
                    Layout.preferredWidth: root.width * 0.18
                    Layout.fillHeight: true
                    color: "transparent"
                    border.color: "#00FFFF"
                    border.width: 1
                    radius: 6

                    Column {
                        anchors.centerIn: parent
                        spacing: root.height * 0.05

                        Repeater {
                            model: ["HOME", "SCAN", "DATABASE", "SETTINGS"]
                            delegate: Text {
                                text: modelData
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.014
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }

                // Scan Area
                Rectangle {
                    Layout.preferredWidth: root.width * 0.48
                    Layout.fillHeight: true
                    color: "transparent"
                    border.color: "#00FFFF"
                    border.width: 1
                    radius: 6

                    Column {
                        anchors.fill: parent
                        anchors.margins: root.width * 0.02
                        spacing: root.height * 0.04

                        Rectangle {
                            width: parent.width * 0.9
                            height: parent.height * 0.7
                            color: "#111"
                            border.color: "#00FFFF"
                            border.width: 2
                            radius: 4

                            Image {
                                anchors.fill: parent
                                source: "qrc:/assets/Face_placeholder.jpeg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            width: parent.width * 0.6
                            height: root.height * 0.07
                            color: "transparent"
                            border.color: "#00FFFF"
                            border.width: 2
                            radius: 4

                            Text {
                                text: "SCAN"
                                anchors.centerIn: parent
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.018
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Scan button clicked")
                            }
                        }
                    }
                }

                // Match Result Panel
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                    border.color: "#00FFFF"
                    border.width: 1
                    radius: 6

                    Column {
                        anchors.fill: parent
                        anchors.margins: root.width * 0.015
                        spacing: root.height * 0.025

                        Text {
                            text: "MATCH RESULT"
                            color: "#00FFFF"
                            font.pixelSize: root.width * 0.016
                            font.bold: true
                        }

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#00FFFF"
                        }

                        Column {
                            spacing: root.height * 0.015

                            Text {
                                text: "NAME"
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.012
                            }

                            Text {
                                text: "JOHN DOE"
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.018
                                font.bold: true
                            }

                            Text {
                                text: "ID"
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.012
                            }

                            Text {
                                text: "A53207"
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.018
                                font.bold: true
                            }

                            Text {
                                text: "SCORE"
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.012
                            }

                            Text {
                                text: "98%"
                                color: "#00FFFF"
                                font.pixelSize: root.width * 0.018
                                font.bold: true
                            }
                        }
                    }
                }
            }
        }
    }
}
