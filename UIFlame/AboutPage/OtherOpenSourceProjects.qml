import QtQuick
import QtQuick.Controls
import "qrc:/jsaddon/jsaddon/file.js" as File

Rectangle {
    width: parent.width
    height: parent.height
    border.color: "#ffffff"

    TextArea {
        text: File.read("qrc:/text/内嵌文档/其它开源组件.md")
        anchors.fill: parent
        wrapMode: Text.Wrap
        layer.smooth: true
        textFormat: Text.MarkdownText
        readOnly: true
        anchors.rightMargin: 34
        anchors.bottomMargin: 0
        anchors.leftMargin: 34
        anchors.topMargin: 0
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/

