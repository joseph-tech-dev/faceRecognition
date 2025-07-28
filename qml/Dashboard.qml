import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: appWindow
    width: Screen.width
    height: Screen.height

    // ==================== PROPERTIES ====================
    // Theme Properties
    property color neonBlue: "#00f2ff"
    property color neonGreen: "#00ffaa"
    property color bgColor: "#0a0f1c"
    property color panelColor: "#111a24"
    property color highlightColor: "#1a2a3a"
    property real borderWidth: 1.5
    property real panelRadius: 8
    property real elementRadius: 6

    // System Properties
    property int localMatches: 42
    property int onlineMatches: 15
    property int pendingSearches: 3
    property real matchAccuracy: 0.92
    property string currentPage: "dashboard"
    property var recentMatches: [
        {name: "John Doe", id: "A53207", confidence: 0.982, source: "local", image: "qrc:/sample_faces/face1.jpg"},
        {name: "Jane Smith", id: "B72193", confidence: 0.957, source: "online", image: "qrc:/sample_faces/face2.jpg"},
        {name: "Alex Wong", id: "C39012", confidence: 0.921, source: "local", image: "qrc:/sample_faces/face3.jpg"}
    ]

    // System Monitor Properties
    property var systemMonitor: ({
        cpuUsage: 45,
        memoryUsage: 68,
        gpuUsage: 32,
        timeRange: "5m",
        refresh: function() {
            //console.log("Refreshing data");
            // Generate some random data for demo purposes
            var newCpu = Math.min(100, Math.max(0, systemMonitor.cpuUsage + (Math.random() * 6 - 3)));
            var newMem = Math.min(100, Math.max(0, systemMonitor.memoryUsage + (Math.random() * 4 - 2)));
            var newGpu = Math.min(100, Math.max(0, systemMonitor.gpuUsage + (Math.random() * 8 - 4)));

            systemMonitor.cpuUsage = Math.round(newCpu);
            systemMonitor.memoryUsage = Math.round(newMem);
            systemMonitor.gpuUsage = Math.round(newGpu);

            // Update history arrays
            systemMonitor.cpuHistory.shift();
            systemMonitor.cpuHistory.push(systemMonitor.cpuUsage);
            systemMonitor.memoryHistory.shift();
            systemMonitor.memoryHistory.push(systemMonitor.memoryUsage);
            systemMonitor.gpuHistory.shift();
            systemMonitor.gpuHistory.push(systemMonitor.gpuUsage);

            activityChart.requestPaint();
        },
        cpuHistory: [45, 48, 52, 50, 47, 45, 43, 40, 42, 45],
        memoryHistory: [68, 67, 66, 67, 68, 69, 68, 67, 68, 68],
        gpuHistory: [32, 30, 28, 30, 32, 35, 33, 32, 31, 32]
    })

    // Layout Properties
    property bool isMobile: width < 900
    property bool isTablet: width >= 900 && width < 1200
    property bool isDesktop: width >= 1200
    property int titleFontSize: isMobile ? 16 : isTablet ? 18 : 20
    property int bodyFontSize: isMobile ? 12 : isTablet ? 14 : 16
    property int smallFontSize: isMobile ? 10 : 12
    property real outerMargin: 15
    property real panelPadding: 15
    property real elementSpacing: 10
    property real innerElementSpacing: 5

    // ==================== MAIN UI ====================
    Rectangle {
        anchors.fill: parent
        color: bgColor
    }

    GridLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: outerMargin
        columns: isMobile ? 1 : 2
        columnSpacing: elementSpacing
        rowSpacing: elementSpacing

        // Navigation Panel
        DashboardPanel {
            id: statsPanel
            title: "NAVIGATION"
            Layout.fillWidth: true
            Layout.preferredHeight: isMobile ? 180 : 200

            GridLayout {
                anchors.fill: parent
                anchors.margins: panelPadding
                columns: isMobile ? 2 : 4
                columnSpacing: elementSpacing
                rowSpacing: elementSpacing

                Repeater {
                    model: [
                        {icon: "🏠", text: "Home", page: "Dashboard"},
                        {icon: "🔍", text: "Scan", page: "FaceScan"},
                        {icon: "⚙️", text: "OSINT", page: "OSINTLookup"},
                        {icon: "🗄️", text: "Database", page: "Database"},
                        {icon: "⚙️", text: "Settings", page: "Settings"}

                    ]

                    NavigationButton {
                        icon: modelData.icon
                        text: modelData.text
                        onClicked: {
                            if (modelData.page === "FaceScan") {
                                stackView.push("FaceScan.qml")
                            }
                            else if (modelData.page === "OSINTLookup") {
                                stackView.push("OSINTLookup.qml")
                            }
                            else {
                                currentPage = modelData.page
                            }
                        }
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
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

                Repeater {
                    model: [
                        {name: "Local Facial Database", entries: "12,453", lastUpdated: "Today", status: "Online"},
                        {name: "Online Recognition API", entries: "∞", lastUpdated: "Live", status: "Connected"}
                    ]

                    DatabaseStatusTile {
                        name: modelData.name
                        entries: modelData.entries
                        lastUpdated: modelData.lastUpdated
                        status: modelData.status
                        Layout.fillWidth: true
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // ==================== BOTTOM ROW ====================
        // System Activity Panel (left side)
        DashboardPanel {
            id: activityPanel
            title: "SYSTEM ACTIVITY"
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !isMobile

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: panelPadding
                spacing: elementSpacing

                // Stats Header Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: elementSpacing * 2

                    StatisticTile {
                        title: "CPU Usage"
                        value: systemMonitor.cpuUsage + "%"
                        statcolor: systemMonitor.cpuUsage > 80 ? "#FF5555" : neonGreen
                        Layout.preferredWidth: 120
                    }

                    StatisticTile {
                        title: "Memory"
                        value: systemMonitor.memoryUsage + "%"
                        statcolor: systemMonitor.memoryUsage > 85 ? "#FF5555" : neonBlue
                        Layout.preferredWidth: 120
                    }

                    StatisticTile {
                        title: "GPU Load"
                        value: systemMonitor.gpuUsage + "%"
                        statcolor: systemMonitor.gpuUsage > 75 ? "#FF5555" : "#AA00FF"
                        Layout.preferredWidth: 120
                    }

                    Item { Layout.fillWidth: true } // Spacer
                }

                // Main Chart Area
                Rectangle {
                    id: chartContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    border.color: neonBlue
                    border.width: 1
                    radius: elementRadius

                    Canvas {
                        id: activityChart
                        anchors.fill: parent
                        anchors.margins: 10

                        property var timePoints: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] // Last 10 seconds
                        property var cpuData: systemMonitor.cpuHistory
                        property var memoryData: systemMonitor.memoryHistory
                        property var gpuData: systemMonitor.gpuHistory

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()

                            // Draw grid lines
                            ctx.strokeStyle = Qt.rgba(0, 0.8, 1, 0.2)
                            ctx.lineWidth = 1

                            // Horizontal grid lines
                            for (var y = 0; y <= 100; y += 20) {
                                ctx.beginPath()
                                var yPos = height - (y/100 * height)
                                ctx.moveTo(0, yPos)
                                ctx.lineTo(width, yPos)
                                ctx.stroke()

                                // Y-axis labels
                                ctx.fillStyle = neonBlue
                                ctx.font = smallFontSize + "px 'Liberation Mono'";
                                ctx.fillText(y + "%", 5, yPos - 5)
                            }

                            // Draw data lines
                            drawLine(ctx, cpuData, neonGreen)
                            drawLine(ctx, memoryData, neonBlue)
                            drawLine(ctx, gpuData, "#AA00FF")

                            // Draw legend
                            drawLegend(ctx)
                        }

                        function drawLine(ctx, data, color) {
                            if (data.length === 0) return

                            ctx.strokeStyle = color
                            ctx.lineWidth = 2
                            ctx.beginPath()

                            var xStep = width / (timePoints.length - 1)
                            var firstY = height - (data[0]/100 * height)
                            ctx.moveTo(0, firstY)

                            for (var i = 1; i < data.length; i++) {
                                var x = i * xStep
                                var y = height - (data[i]/100 * height)
                                ctx.lineTo(x, y)
                            }

                            ctx.stroke()
                        }

                        function drawLegend(ctx) {
                            var legendItems = [
                                { text: "CPU", color: neonGreen },
                                { text: "Memory", color: neonBlue },
                                { text: "GPU", color: "#AA00FF" }
                            ]

                            var boxSize = 15
                            var padding = 10
                            var startX = width - 150
                            var startY = 10

                            ctx.font = smallFontSize + "px 'Liberation Mono'";

                            legendItems.forEach(function(item, index) {
                                var y = startY + index * (boxSize + padding)

                                // Color box
                                ctx.fillStyle = item.color
                                ctx.fillRect(startX, y, boxSize, boxSize)

                                // Text
                                ctx.fillStyle = neonBlue
                                ctx.fillText(item.text, startX + boxSize + 5, y + boxSize - 3)
                            })
                        }
                    }
                }

                // Timeline controls
                RowLayout {
                    Layout.fillWidth: true
                    spacing: elementSpacing

                    Repeater {
                        model: ["1m", "5m", "15m", "30m", "1h"]
                        Button {
                            text: modelData
                            font.family: "Courier New"
                            font.pixelSize: smallFontSize
                            background: Rectangle {
                                color: parent.pressed ? highlightColor :
                                       parent.hovered ? Qt.darker(panelColor, 1.2) :
                                       Qt.darker(panelColor, 1.1)
                                radius: elementRadius
                                border.color: neonBlue
                                border.width: 1
                            }
                            contentItem: Text {
                                text: parent.text
                                color: neonBlue
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font: parent.font
                            }
                            onClicked: systemMonitor.timeRange = modelData
                        }
                    }

                    Item { Layout.fillWidth: true } // Spacer

                    Button {
                        text: "⟳"
                        font.pixelSize: bodyFontSize
                        background: Rectangle {
                            color: parent.pressed ? highlightColor :
                                   parent.hovered ? Qt.darker(panelColor, 1.2) :
                                   Qt.darker(panelColor, 1.1)
                            radius: elementRadius
                            border.color: neonBlue
                            border.width: 1
                        }
                        contentItem: Text {
                            text: parent.text
                            color: neonBlue
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font
                        }
                        onClicked: systemMonitor.refresh()
                    }
                }
            }

            // Timer to update chart
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    systemMonitor.refresh();
                }
            }
        }

        // Recent Matches Panel (right side)
        DashboardPanel {
            id: matchesPanel
            title: "RECENT MATCHES"
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
    }

    // ==================== COMPONENTS ====================
    component DashboardPanel: Rectangle {
        property string title
        property alias contentItem: contentContainer.data

        color: panelColor
        border.color: neonBlue
        border.width: borderWidth
        radius: panelRadius

        ColumnLayout {
            anchors.fill: parent
            spacing: elementSpacing

            Text {
                text: title
                color: neonBlue
                font.pixelSize: titleFontSize
                font.bold: true
                font.family: "Courier New"
                leftPadding: panelPadding
                topPadding: panelPadding
            }

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

    component DatabaseStatusTile: Rectangle {
        property string name
        property var entries
        property string lastUpdated
        property string status

        height: 70
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
}
