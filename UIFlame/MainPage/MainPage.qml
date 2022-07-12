import QtQuick
import QtQuick.Window

import "../Menu"

Window {
    id: root
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("北镇闾山景区巡查监测平台")

    Loader {
        id: windowloader
    }

    Flow {
        id: mainflow
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        width: root.width
        height: root.height
        spacing: 5
    }

    Rectangle {
        id: topbar
        x: 0
        z: 0
        width: root.width
        height: 60

        Rectangle {
            z: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#292929"
                }
                GradientStop {
                    position: 1.0
                    color: "#828282"
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("北镇闾山景区巡查监测平台")
                font.pixelSize: 24
            }
        }
    }

    Rectangle {
        id: menubar
        y: topbar.y + topbar.height
        width: 300
        height: root.height - topbar.height - 5
        border.color: "#EEEEEE"
        Menu {
            y: 2
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#000000";formeditorZoom:0.5;height:1080;width:1920}
}
##^##*/

