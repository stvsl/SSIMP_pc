import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Window
import QtWebEngine
import QtWebChannel

Item {
    anchors.fill: parent
    Text {
        width: parent.width
        height: 40
        color: "#8E99A5"
        text: qsTr("全局概览")
        font.styleName: "Demibold"
        font.pointSize: 25
    }
    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.topMargin: 50
        radius: 10
        clip: true
        color: "transparent"
        WebEngineView {
            id: webview
            anchors.fill: parent
            clip: true
        }
    }
    Component.onCompleted: {
        webview.url="qrc:/htmlpage/htmlpage/mainscreenview.html"
    }
}