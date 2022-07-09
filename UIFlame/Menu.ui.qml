

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick

ListView {
    id: view
    width: 300
    height: 600

    highlightMoveDuration: 0

    children: [
        Rectangle {
            color: "#EEEEEE"
            anchors.fill: parent
            z: -1
        }
    ]

    model: MenuModel {}

    highlight: Rectangle {
        width: view.width
        height: 20
        color: "#0C96FF"
        radius: 4
        border.color: "#EEEEEE"
        border.width: 0
    }

    delegate: MenuDelegate {}
}
