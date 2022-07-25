import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: msgbox
    width: 480
    height: 200
    visible: true
    color: Qt.rgba(0, 0, 0, 0)
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    // 消息弹窗类型：tips：提示窗口 | msg：消息窗口 | warn：警告窗口 | error：错误窗口
    property string type: "tips"
    // 消息弹窗标题
    property string texts: "请设置消息弹窗标题"
    // 消息弹窗内容
    property string helptext: "请设置消息弹窗内容"
    // 按钮类型 确定 | 取消
    property bool conform: true
    // 按钮类型 是 | 否
    property bool yesorno: true
    Rectangle {
        anchors.fill: parent
        color: "white"
        visible: true
        radius: 15
        border.color: "#EEEEEE"
        border.width: 1
        Label {
            id: type
            x: 22
            y: 15
            width: 45
            height: 30
            // 判断消息类型，设置不同的样式
            text: msgbox.type === "tips" ? "提示" : msgbox.type
                                           === "msg" ? "消息" : msgbox.type === "warn" ? "警告" : "错误"
            color: Qt.rgba(0, 0, 0, 0.86)
            font.bold: true
            font.pointSize: 16
        }
        Text {
            id: texts
            x: type.x + type.width / 2
            y: type.y + type.height + 5
            width: msgbox.width / 1.5
            text: msgbox.texts
            color: Qt.rgba(0, 0, 0, 0.76)
            font.bold: true
            font.pixelSize: 16
        }
        Text {
            id: helptext
            x: texts.x
            y: texts.y + texts.height + 3
            text: "        " + msgbox.helptext
            font.letterSpacing: 0.5
            width: msgbox.width / 1.2
            height: msgbox.height / 3
            color: Qt.rgba(0, 0, 0, 0.56)
            font.bold: true
            wrapMode: Text.WrapAnywhere
            elide: Text.ElideRight
            font.wordSpacing: 0.1
            lineHeight: 1
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton //只处理鼠标左键
            property point clickPos: "0,0"
            onPressed: mouse => {
                           //接收鼠标按下事件
                           clickPos = Qt.point(mouse.x, mouse.y)
                       }
            onPositionChanged: mouse => {
                                   //鼠标按下后改变位置
                                   //鼠标偏移量
                                   var delta = Qt.point(mouse.x - clickPos.x,
                                                        mouse.y - clickPos.y)

                                   //如果mainwindow继承自QWidget,用setPos
                                   msgbox.setX(msgbox.x + delta.x)
                                   msgbox.setY(msgbox.y + delta.y)
                               }
        }
        MsgButton {}
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#000000"}
}
##^##*/

