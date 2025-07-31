// OSINTLookup.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt.labs.platform 1.1

Item {
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600
    property StackView stackView
    property string inputText: ""
    property bool isSearching: false

    // Theme properties
    property color neonBlue: "#00f2ff"
    property color neonBlueDark: "#006a71"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color textColor: "#ffffff"
    property real borderWidth: 1.5
    property real globalMargin: 15

    Rectangle {
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
                    ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, height); ctx.stroke();
                }
                for (var y = 0; y < height; y += 30) {
                    ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke();
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: globalMargin
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "transparent"
                RowLayout {
                    anchors.fill: parent
                    spacing: 20

                    Text {
                        text: "ZEPHIX"
                        font.family: "Courier New"
                        font.bold: true
                        font.pixelSize: 18
                        font.letterSpacing: 1
                        color: neonBlue
                    }

                    Rectangle {
                        width: 80
                        height: 30
                        radius: 4
                        color: Qt.darker(panelColor, 1.2)
                        border.color: neonBlue
                        border.width: borderWidth

                        Text {
                            anchors.centerIn: parent
                            text: "Home"
                            color: neonBlue
                            font.family: "Courier New"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: parent.color = Qt.rgba(0, 1, 1, 0.15)
                            onExited: parent.color = Qt.darker(panelColor, 1.2)
                            onClicked: {
                                if (stackView) {
                                    stackView.pop()
                                } else {
                                    console.warn("No stackView available to pop")
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    StatusIndicator {
                        status: "ONLINE"
                        color: neonBlue
                    }

                    Text {
                        text: Qt.formatTime(new Date(), "hh:mm")
                        font.family: "Courier New"
                        font.pixelSize: 16
                        color: neonBlue
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: neonBlue
                    opacity: 0.3
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            height: 45
                            radius: 6
                            color: Qt.darker(panelColor, 1.1)
                            border.color: neonBlue
                            border.width: borderWidth

                            TextField {
                                id: searchField
                                anchors.fill: parent
                                anchors.margins: 10
                                placeholderText: "username / email / phone"
                                placeholderTextColor: Qt.lighter(neonBlue, 1.3)
                                color: neonBlue
                                font.family: "Courier New"
                                font.pixelSize: 14
                                background: Rectangle { color: "transparent" }
                                onTextChanged: inputText = text
                            }
                        }

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
                                font.family: "Courier New"
                                font.bold: true
                                font.pixelSize: 16
                                font.letterSpacing: 1
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = Qt.rgba(0, 0.95, 1, 0.1)
                                onExited: parent.color = "transparent"
                                onClicked: performSearch()
                            }
                        }

                        // Busy Indicator
                        BusyIndicator {
                            running: isSearching
                            visible: isSearching
                            Layout.alignment: Qt.AlignHCenter
                            width: 30
                            height: 30
                        }
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        ListView {
                            model: OsintManager.osintResults
                            delegate: Rectangle {
                                width: parent.width
                                height: 100
                                radius: 6
                                color: panelColor
                                border.color: neonBlue
                                border.width: borderWidth

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 6
                                    Text {
                                        text: "[" + (modelData.platform || "Unknown") + "] " + (modelData.url || "")
                                        font.family: "Courier New"
                                        font.pixelSize: 14
                                        color: neonBlue
                                        wrapMode: Text.WrapAnywhere
                                    }

                                    Text {
                                        text: modelData.data || modelData.status || "No details"
                                        font.family: "Courier New"
                                        font.pixelSize: 12
                                        color: textColor
                                    }

                                    Text {
                                        text: modelData.timestamp || ""
                                        font.family: "Courier New"
                                        font.pixelSize: 10
                                        color: Qt.lighter(textColor, 1.5)
                                    }

                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: OsintManager.openUrl(model.url)
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function performSearch() {
        if (!inputText || inputText.length < 3)
            return;

        isSearching = true
        console.log("Searching:", inputText)

        OsintManager.search(inputText)

        OsintManager.osintResultsChanged.connect(function() {
            isSearching = false
        })
    }

    function openSettings() {
        console.log("Opening settings")
    }

    component StatusIndicator : Text {
        property string status: "ONLINE"
        property color pcolor: neonBlue
        text: status
        font.family: "Courier New"
        font.pixelSize: 14
        color: pcolor
        Rectangle {
            width: 8; height: 8; radius: 4
            color: parent.color
            anchors.right: parent.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
