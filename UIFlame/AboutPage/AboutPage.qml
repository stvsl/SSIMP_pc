import QtQuick
import QtQuick.Controls
import QtQuick.Window

Item {
    id: aboutpage
    layer.smooth: true

    ListView {
        id: title
        anchors.left: parent.left
        anchors.top: parent.top
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 0
        keyNavigationWraps: true
        anchors.topMargin: 20
        anchors.leftMargin: 60
        layer.enabled: false
        focus: false
        layer.smooth: true
        spacing: 15
        width: 90
        anchors.verticalCenter: parent.verticalCenter
        height: 800
        currentIndex: view.currentIndex

        model: ListModel {
            ListElement {
                name: qsTr("关于Qt")
                img: "qrc:/icon/AboutPage/icon/AboutPage/qtlogo.png"
            }
            ListElement {
                name: qsTr("关于Qml")
                img: "qrc:/icon/AboutPage/icon/AboutPage/qmllogo.png"
            }
            ListElement {
                name: qsTr("关于此软件")
                img: "qrc:/icon/AboutPage/icon/AboutPage/关于软件.png"
            }
            ListElement {
                name: qsTr("关于我们")
                img: "qrc:/icon/AboutPage/icon/AboutPage/关于我们.png"
            }
            ListElement {
                name: qsTr("其它开源组件")
                img: "qrc:/icon/AboutPage/icon/AboutPage/其它开源组件.png"
            }
        }
        delegate: Rectangle {
            id: aboutitems
            width: title.width
            height: 100
            radius: 5
            color: view.currentIndex === index ? "#EEEEEE" : "#FFFFFF"
            property bool ishover: false

            Image {
                y: 10
                anchors.topMargin: 5
                width: aboutitems.width - 40
                height: 50
                source: img
                autoTransform: true
                anchors.horizontalCenter: aboutitems.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }

            Text {
                y: 70
                text: name
                color: "#666666"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: aboutitems.horizontalCenter
                layer.smooth: true
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    view.currentIndex = index
                }
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "white"
        radius: 5
        border.width: 1
        border.color: "#DDDDEE"
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 220
        anchors.topMargin: 10

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            clip: true
            layer.smooth: true
            SwipeView {
                id: view
                anchors.fill: parent
                anchors.topMargin: 5
                layer.smooth: true

                Item {
                    id: aboutQt
                    AboutQt {}
                }
                Item {
                    id: aboutQml
                    AboutQml {}
                }
                Item {
                    id: aboutSoftware
                    AboutSoftware {}
                }
                Item {
                    id: aboutUs
                    AboutUS {}
                }
                Item {
                    id: otherOpenSourceProjects
                    OtherOpenSourceProjects {}
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
    D{i:0;autoSize:true;formeditorColor:"#c0c0c0";formeditorZoom:0.5;height:1074;width:1600}
}
##^##*/

