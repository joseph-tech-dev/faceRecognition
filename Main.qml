import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 1280
    height: 700
    title: "XPERSKEY"
    color: "black"

    StackView {
        id: stackView
        anchors.fill: parent

        Component.onCompleted: {
            // Use full path with qrc:/ prefix
            var component = Qt.createComponent("qrc:/qml/LoginPage.qml")
            if (component.status === Component.Ready) {
                var loginPage = component.createObject(stackView, {
                    stackView: stackView
                })
                stackView.push(loginPage)
            } else {
                console.error("Error loading LoginPage:", component.errorString())
            }
        }
    }
}
