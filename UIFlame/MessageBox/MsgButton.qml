/*##^##
Designer {
    D{i:0;formeditorColor:"#000000"}
}
##^##*/

import QtQuick
import QtQuick.Controls

Flow {
    width: parent.width
    height: 40
    anchors.top: helptext.bottom
    spacing: 10
    topPadding: 2
    rightPadding: 20
    padding: 2
    clip: true
    layoutDirection: Qt.RightToLeft
    flow: Flow.LeftToRight

    Rectangle {
        id: canclebtn

        width: parent.width / 5
        height: parent.height - 5
        color: Qt.rgba(0, 0.4, 1, 1)
        visible: msgbox.justconform ? false : msgbox.conform ? true : msgbox.yesorno ? true : false
        radius: 5

        Text {
            text: qsTr("取消")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: canclebtn.horizontalCenter
            anchors.verticalCenter: canclebtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                canclebtn.color = Qt.rgba(0, 0.4, 1, 0.8);
                msgbox.btnClicked(4);
            }
            onReleased: {
                canclebtn.color = Qt.rgba(0, 0.4, 1, 1);
            }
        }

    }

    Rectangle {
        id: okbtn

        width: parent.width / 5
        height: parent.height - 5
        color: Qt.rgba(0, 0.4, 1, 1)
        visible: msgbox.conform ? true : false
        radius: 5

        Text {
            text: qsTr("确认")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: okbtn.horizontalCenter
            anchors.verticalCenter: okbtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                okbtn.color = Qt.rgba(0, 0.4, 1, 0.8);
                msgbox.btnClicked(3);
            }
            onReleased: {
                okbtn.color = Qt.rgba(0, 0.4, 1, 1);
            }
        }

    }

    Rectangle {
        id: nobtn

        width: parent.width / 5
        height: parent.height - 5
        color: Qt.rgba(0, 0.4, 1, 1)
        visible: msgbox.yesorno
        radius: 5

        Text {
            text: qsTr("否")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: nobtn.horizontalCenter
            anchors.verticalCenter: nobtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                nobtn.color = Qt.rgba(0, 0.4, 1, 0.8);
                msgbox.btnClicked(2);
            }
            onReleased: {
                nobtn.color = Qt.rgba(0, 0.4, 1, 1);
            }
        }

    }

    Rectangle {
        id: yesbtn

        width: parent.width / 5
        height: parent.height - 5
        color: Qt.rgba(0, 0.4, 1, 1)
        visible: msgbox.yesorno
        radius: 5

        Text {
            text: qsTr("是")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: yesbtn.horizontalCenter
            anchors.verticalCenter: yesbtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                yesbtn.color = Qt.rgba(0, 0.4, 1, 0.8);
                msgbox.btnClicked(1);
            }
            onReleased: {
                yesbtn.color = Qt.rgba(0, 0.4, 1, 1);
            }
        }

    }

}
