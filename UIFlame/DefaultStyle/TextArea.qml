import QtQuick
import QtQuick.Controls

TextArea {
    id: control
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        color: "transparent"
    }
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        height: 2
        color: "gray"
    }
}