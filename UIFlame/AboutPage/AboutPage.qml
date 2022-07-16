import QtQuick
import QtQuick.Controls
import QtQuick.Window

Item {
    id: aboutpage
    anchors.fill: parent

    ListView {
        id: title
        anchors.left: parent.left
        layer.enabled: false
        focus: false
        layer.smooth: true
        spacing: 10
        width: 120
        anchors.verticalCenter: parent.verticalCenter
        height: 800
        model: ListModel {
            ListElement {
                name: qsTr("关于Qt")
            }
            ListElement {
                name: qsTr("关于Qml")
            }
            ListElement {
                name: qsTr("关于我们")
            }
        }
        delegate: Button {
            width: title.width
            height: 150
            text: name
        }
        highlight: Button {
            width: title.width
            height: 150
            text: name
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "white"
        radius: 5
        border.width: 1
        border.color: "#eeeeee"
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 140
        anchors.topMargin: 10

        Rectangle {
            anchors.fill: parent
            clip: true
            layer.smooth: true
            SwipeView {
                id: view
                anchors.fill: parent
                layer.smooth: true

                Item {
                    id: aboutQt
                    AboutQt {}
                }
                Item {
                    id: aboutQml
                    Text {
                        text: qsTr("2vxzvbdfxcvdfzxcgvdfzh")
                    }
                }
                Item {
                    id: aboutUs
                    Text {
                        text: qsTr("3156445116451856456")
                    }
                }
            }
            PageIndicator {
                id: indicator
                count: view.count
                currentIndex: view.currentIndex
                anchors.bottom: view.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.66;height:1074;width:1600}
}
##^##*/

