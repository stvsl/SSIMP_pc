import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

TextField {
    id: control
    // 文字居中
    verticalAlignment: Text.AlignVCenter
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        color: "transparent"
    }
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.right: parent.right
        height: 2
        color: "gray"
    }
}
