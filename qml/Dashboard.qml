import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: appWindow
    width: Screen.width
    height: Screen.height
    //minimumWidth: 800
    //minimumHeight: 600
    //title: "FACEINTEL Recognition System"

    // Theme properties
    property color neonBlue: "#00f2ff"
    property color neonGreen: "#00ffaa"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color highlightColor: "#1a2a3a"
    property real borderWidth: 1.5
    property real panelRadius: 8
    property real elementRadius: 6

    // System state
    property int localMatches: 42
    property int onlineMatches: 15
    property int pendingSearches: 3
    property real matchAccuracy: 0.92
    property var recentMatches: [
        {name: "John Doe", id: "A53207", confidence: 0.982, source: "local", image: "qrc:/sample_faces/face1.jpg"},
        {name: "Jane Smith", id: "B72193", confidence: 0.957, source: "online", image: "qrc:/sample_faces/face2.jpg"},
        {name: "Alex Wong", id: "C39012", confidence: 0.921, source: "local", image: "qrc:/sample_faces/face3.jpg"}
    ]

    // Responsive layout properties
    property bool isMobile: width < 900
    property bool isTablet: width >= 900 && width < 1200
    property bool isDesktop: width >= 1200

    // Font sizes
    property int titleFontSize: isMobile ? 16 : isTablet ? 18 : 20
    property int bodyFontSize: isMobile ? 12 : isTablet ? 14 : 16
    property int smallFontSize: isMobile ? 10 : 12

    // Spacing constants
    property real outerMargin: 15
    property real panelPadding: 15
    property real elementSpacing: 10
    property real innerElementSpacing: 5

    // Background
    Rectangle {
        anchors.fill: parent
        color: bgColor
    }

    // Main layout
    GridLayout {
        id: mainLayout
        anchors {
            fill: parent
            margins: outerMargin
        }
        columns: isMobile ? 1 : 2
        columnSpacing: elementSpacing
        rowSpacing: elementSpacing

        // ==================== TOP ROW ====================
        // Statistics Panel
        DashboardPanel {
            id: statsPanel
            title: "MATCH STATISTICS"
            Layout.fillWidth: true
            Layout.preferredHeight: isMobile ? 180 : 200
            // In the Statistics Panel section (replace the existing GridLayout content):
            GridLayout {
                anchors.fill: parent
                anchors.margins: 15
                columns: isMobile ? 2 : 4
                columnSpacing: 15
                rowSpacing: 15

                NavigationButton {
                    icon: "🏠"
                    text: "Home"
                    onClicked: currentPage = "dashboard"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                NavigationButton {
                    icon: "🔍"
                    text: "Scan"
                    onClicked: currentPage = "scan"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                NavigationButton {
                    icon: "🗄️"
                    text: "Database"
                    onClicked: currentPage = "database"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                NavigationButton {
                    icon: "⚙️"
                    text: "Settings"
                    onClicked: currentPage = "settings"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            // Add this new component definition at the bottom with the other components:
            component NavigationButton: Rectangle {
                property string icon
                property string text
                signal clicked

                radius: elementRadius
                color: Qt.darker(panelColor, 1.1)
                border.color: neonBlue
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: innerElementSpacing

                    Text {
                        text: icon
                        font.pixelSize: bodyFontSize + 10
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: parent.parent.text
                        color: neonBlue
                        font.pixelSize: bodyFontSize
                        font.bold: true
                        font.family: "Courier New"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.color = highlightColor
                    onExited: parent.color = Qt.darker(panelColor, 1.1)
                    onClicked: parent.clicked()
                }
            }

            // Add this property to track current page:
            property string currentPage: "dashboard"
        }

        // Database Status Panel
        DashboardPanel {
            id: databasePanel
            title: "DATABASE STATUS"
            Layout.fillWidth: true
            Layout.preferredHeight: isMobile ? 160 : 200

            ColumnLayout {
                anchors.fill: parent
                spacing: elementSpacing

                DatabaseStatusTile {
                    name: "Local Facial Database"
                    entries: "12,453"
                    lastUpdated: "Today"
                    status: "Online"
                    Layout.fillWidth: true
                }

                DatabaseStatusTile {
                    name: "Online Recognition API"
                    entries: "∞"
                    lastUpdated: "Live"
                    status: "Connected"
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true } // Spacer
            }
        }

        // ==================== BOTTOM ROW ====================
        // Recent Matches Panel
        DashboardPanel {
            id: matchesPanel
            title: "RECENT MATCHES"
            Layout.columnSpan: isMobile ? 1 : 2
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: matchesList
                anchors.fill: parent
                clip: true
                model: recentMatches
                spacing: innerElementSpacing

                delegate: MatchResultTile {
                    width: matchesList.width
                    height: isMobile ? 100 : 120
                    matchData: modelData
                }
            }
        }

        // System Activity Panel (only shown on desktop)
        DashboardPanel {
            id: activityPanel
            title: "SYSTEM ACTIVITY"
            Layout.columnSpan: isMobile ? 1 : 2
            Layout.fillWidth: true
            Layout.preferredHeight: isMobile ? 0 : 200
            visible: !isMobile

            ActivityChartPlaceholder {
                anchors.fill: parent
            }
        }
    }

    // ==================== COMPONENT DEFINITIONS ====================
    component DashboardPanel: Rectangle {
        property string title
        property alias contentItem: contentContainer.data

        Layout.fillWidth: true
        color: panelColor
        border.color: neonBlue
        border.width: borderWidth
        radius: panelRadius

        ColumnLayout {
            anchors.fill: parent
            spacing: elementSpacing

            // Panel header
            Text {
                text: title
                color: neonBlue
                font.pixelSize: titleFontSize
                font.family: "Courier New"
                font.bold: true
                leftPadding: panelPadding
                topPadding: panelPadding
            }

            // Content area
            Item {
                id: contentContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: panelPadding
                Layout.rightMargin: panelPadding
                Layout.bottomMargin: panelPadding
            }
        }
    }

    component StatisticTile: Rectangle {
        property string title
        property var value
        property color statcolor: neonBlue

        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: elementRadius
        color: Qt.darker(panelColor, 1.1)
        border.color: neonBlue
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: innerElementSpacing

            Text {
                text: title
                color: neonBlue
                opacity: 0.7
                font.pixelSize: smallFontSize
                font.family: "Courier New"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: value
                color: statcolor
                font.pixelSize: bodyFontSize + 4
                font.bold: true
                font.family: "Courier New"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    component DatabaseStatusTile: Rectangle {
        property string name
        property var entries
        property string lastUpdated
        property string status

        Layout.preferredHeight: 70
        radius: elementRadius
        color: Qt.darker(panelColor, 1.1)
        border.color: neonBlue
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: panelPadding / 2
            spacing: innerElementSpacing

            Text {
                text: name
                color: neonBlue
                font.pixelSize: bodyFontSize
                font.bold: true
                font.family: "Courier New"
                width: parent.width
                elide: Text.ElideRight
            }

            Row {
                width: parent.width
                spacing: elementSpacing

                Column {
                    spacing: innerElementSpacing

                    Text {
                        text: "Entries:"
                        color: neonBlue
                        opacity: 0.7
                        font.pixelSize: smallFontSize
                        font.family: "Courier New"
                    }

                    Text {
                        text: entries
                        color: neonBlue
                        font.pixelSize: smallFontSize + 2
                        font.family: "Courier New"
                    }
                }

                Column {
                    spacing: innerElementSpacing

                    Text {
                        text: "Last Updated:"
                        color: neonBlue
                        opacity: 0.7
                        font.pixelSize: smallFontSize
                        font.family: "Courier New"
                    }

                    Text {
                        text: lastUpdated
                        color: neonBlue
                        font.pixelSize: smallFontSize + 2
                        font.family: "Courier New"
                    }
                }

                Item { width: 10; height: 1 }

                Rectangle {
                    width: 70
                    height: 20
                    radius: 3
                    color: "transparent"
                    border.color: status === "Online" || status === "Connected" ? neonGreen : "#FFAA00"
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: status
                        color: status === "Online" || status === "Connected" ? neonGreen : "#FFAA00"
                        anchors.centerIn: parent
                        font.pixelSize: smallFontSize
                        font.bold: true
                        font.family: "Courier New"
                    }
                }
            }
        }
    }

    component MatchResultTile: Rectangle {
        property var matchData

        radius: elementRadius
        color: Qt.darker(panelColor, 1.1)
        border.color: neonBlue
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: panelPadding / 2
            spacing: elementSpacing

            // Face thumbnail
            Rectangle {
                width: isMobile ? 80 : 100
                height: width
                radius: 4
                color: "black"
                border.color: neonBlue
                border.width: 1

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: matchData.image
                    fillMode: Image.PreserveAspectFit
                }
            }

            // Match details
            Column {
                width: parent.width - (isMobile ? 110 : 130)
                spacing: innerElementSpacing
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: matchData.name
                    color: neonBlue
                    font.pixelSize: bodyFontSize
                    font.bold: true
                    font.family: "Courier New"
                    width: parent.width
                    elide: Text.ElideRight
                }

                Text {
                    text: "ID: " + matchData.id
                    color: neonBlue
                    opacity: 0.8
                    font.pixelSize: smallFontSize + 2
                    font.family: "Courier New"
                }

                Text {
                    text: "Confidence: " + (matchData.confidence * 100).toFixed(1) + "%"
                    color: matchData.confidence > 0.9 ? neonGreen : neonBlue
                    font.pixelSize: smallFontSize + 2
                    font.family: "Courier New"
                }

                Text {
                    text: "Source: " + (matchData.source === "local" ? "Local Database" : "Online Database")
                    color: neonBlue
                    opacity: 0.7
                    font.pixelSize: smallFontSize
                    font.family: "Courier New"
                }
            }
        }
    }

    component ActivityChartPlaceholder: Rectangle {
        color: Qt.darker(panelColor, 1.1)
        border.color: neonBlue
        border.width: 1
        radius: elementRadius

        Text {
            text: "ACTIVITY CHART AREA"
            color: neonBlue
            opacity: 0.5
            font.pixelSize: bodyFontSize
            font.family: "Courier New"
            anchors.centerIn: parent
        }
    }
}
