import QtQuick
import QtQuick.Controls
import "qrc:/jsaddon/jsaddon/file.js" as File

Rectangle {
    width: parent.width
    height: parent.height


    TextArea {
        z:0
        text: File.read("qrc:/text/内嵌文档/关于我们.md")
        anchors.fill: parent
        wrapMode: Text.Wrap
        textFormat: Text.MarkdownText
        readOnly: true
        anchors.rightMargin: 27
        anchors.bottomMargin: 0
        anchors.leftMargin: 41
        anchors.topMargin: 0
    }
    Image {
        id: image
        z:1
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width/5
        height: parent.height/3
        source: "qrc:/picture/aboutpage/picture/aboutpage/爱莉希雅.png"
        fillMode: Image.PreserveAspectFit
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75;height:600;width:900}
}
##^##*/

