import QtQuick
import QtQuick.Controls
import QtQuick.Window

Item {
    id: aboutpage
    anchors.fill: parent
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
                    id: first
                    Text {
                        text: qsTr("1dgdzsffgxcvsdfdfg")
                    }
                }
                Item {
                    id: second
                    Text {
                        text: qsTr("2vxzvbdfxcvdfzxcgvdfzh")
                    }
                }
                Item {
                    id: thired
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

    Rectangle {
        id: rectangle
        x: 8
        y: 104
        width: 120
        height: 150
        color: "#ffffff"

        Image {
            id: image
            width: 100
            height: 100
            source: "qrc:/qtquickplugin/images/template_image.png"
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }

        Text {
            y: 110
            text: qsTr("Text")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                view.currentIndex = 1
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.5;height:1074;width:1600}
D{i:12}D{i:13}
}
##^##*/

