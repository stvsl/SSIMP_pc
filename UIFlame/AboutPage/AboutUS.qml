import QtQuick
import QtQuick.Controls
import "qrc:/jsaddon/jsaddon/file.js" as File

Rectangle {
    width: parent.width
    height: parent.height

    TextArea {
        text: File.read("qrc:/text/内嵌文档/关于我们.md")
        anchors.fill: parent
        wrapMode: Text.Wrap
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

