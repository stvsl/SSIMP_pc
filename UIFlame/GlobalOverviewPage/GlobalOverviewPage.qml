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
        layer.enabled: true
        radius: 10
        clip: true

        WebEngineView {
            id: webview
            anchors.fill: parent
            anchors.margins: 5
            clip: true
            url: "qrc:/htmlpage/htmlpage/mainscreenview.html"
        }
        layer.effect: DropShadow {
            cached: true
            color: "#90849292"
            horizontalOffset: 3
            verticalOffset: 3
            radius: 10
            samples: 2 * radius + 1
        }
    }
}