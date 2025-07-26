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
            var loginPage = Qt.createComponent("qrc:/qml/LoginPage.qml").createObject(stackView, {
                stackView: stackView
            })
            stackView.push(loginPage)
        }
    }
}
