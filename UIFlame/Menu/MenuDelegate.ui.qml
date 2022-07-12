

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Shapes

Item {
    id: delegate
    width: ListView.view.width
    height: 60

    Rectangle {
        id: rectangle
        color: "#FFFFFF"
        anchors.fill: parent
        anchors.margins: 2
        visible: true
        Shape {
            anchors.fill: parent
            ShapePath {
                strokeWidth: 0
                strokeColor: "black"
                strokeStyle: ShapePath.SolidLine
                startX: 15
                startY: 0
                PathLine {
                    x: parent.width - 15
                    y: 0
                }
            }
        }
    }

    Text {
        id: label
        color: "#343434"
        text: name
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    MouseArea {
        anchors.fill: parent
        onClicked: delegate.ListView.view.currentIndex = index
    }
    states: [
        State {
            name: "Highlighted"

            when: delegate.ListView.isCurrentItem
            PropertyChanges {
                target: label
                color: "#323643"
                anchors.topMargin: 30
            }

            PropertyChanges {
                target: rectangle
                visible: false
            }
        }
    ]
}