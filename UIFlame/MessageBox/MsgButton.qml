import QtQuick
import QtQuick.Controls

Flow {
    width: parent.width
    height: 40
    anchors.top: helptext.bottom
    spacing: 10
    topPadding: 5
    rightPadding: 25
    padding: 2
    clip: true
    layoutDirection: Qt.RightToLeft
    flow: Flow.LeftToRight

    Rectangle {
        id: canclebtn
        width: parent.width / 5.2
        height: parent.height - 5
        color: "#42C2FF"
        border.color: "#EEEEEE"
        border.width: 1
        visible: msgbox.conform ? true : msgbox.yesorno ? true : false
        Text {
            text: qsTr("取消")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: canclebtn.horizontalCenter
            anchors.verticalCenter: canclebtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                canclebtn.color = "#32B2EF"
                console.log("!!!")
            }
        }
        radius: 5
    }
    Rectangle {
        id: okbtn
        width: parent.width / 5.2
        height: parent.height - 5
        color: "#42C2FF"
        border.color: "#EEEEEE"
        border.width: 1
        visible: msgbox.conform ? true : false
        Text {
            text: qsTr("确认")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: okbtn.horizontalCenter
            anchors.verticalCenter: okbtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                okbtn.color = "#32B2EF"
                console.log("!!!")
            }
        }
        radius: 5
    }
    Rectangle {
        id: nobtn
        width: parent.width / 5.2
        height: parent.height - 5
        color: "#42C2FF"
        border.color: "#EEEEEE"
        border.width: 1
        visible: msgbox.yesorno
        Text {
            text: qsTr("否")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: nobtn.horizontalCenter
            anchors.verticalCenter: nobtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                nobtn.color = "#32B2EF"
                console.log("!!!")
            }
        }
        radius: 5
    }
    Rectangle {
        id: yesbtn
        width: parent.width / 5.2
        height: parent.height - 5
        color: "#42C2FF"
        border.color: "#EEEEEE"
        border.width: 1
        visible: msgbox.yesorno
        Text {
            text: qsTr("是")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: yesbtn.horizontalCenter
            anchors.verticalCenter: yesbtn.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                yesbtn.color = "#32B2EF"
                console.log("!!!")
            }
        }
        radius: 5
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#000000"}
}
##^##*/

