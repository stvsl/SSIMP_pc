import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../Menu"
import "../AboutPage"

Window {
    id: root
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("北镇闾山景区巡查监测平台")
    onClosing: {
        daemon.close()
    }

    Flow {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        width: root.width
        height: root.height
        spacing: 10
    }

    Rectangle {
        id: topbar
        x: 0
        z: 0
        width: root.width
        height: 70
        border.width: 0
        smooth: true
        Rectangle {
            z: 1
            anchors.verticalCenter: topbar.verticalCenter
            anchors.left: parent.left
            visible: true
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(width, height)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "#005be0"
                    }

                    GradientStop {
                        position: 1.0
                        color: "#00c6fb"
                    }
                }
            }

            height: 70
            width: 300

            Text {
                x: 6
                z: 15
                anchors.verticalCenter: parent.verticalCenter
                color: "#FFFFFF"
                text: qsTr("北镇闾山景区巡查监测平台")
                font.pixelSize: 24
            }
        }
        Rectangle {
            id: menubar
            y: topbar.y + topbar.height
            width: 300
            height: root.height - topbar.height - 1
            border.color: "#EEEEEE"
            Menu {
                id: menu
                y: 20
                width: 290
                height: 938
                boundsMovement: Flickable.StopAtBounds
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Component {
            id: globaloverview
            Rectangle {
                width: 200
                height: 100
                color: "blue"
            }
        }

        Component {
            id: datamonitoring
            Rectangle {
                width: 200
                height: 100
                color: "blue"
            }
        }

        Component {
            id: staffmanagement
            Rectangle {
                width: 200
                height: 100
                color: "orange"
            }
        }

        Component {
            id: worktask
            Rectangle {
                width: 200
                height: 100
                color: "green"
            }
        }

        Component {
            id: contentmanagement
            Rectangle {
                width: 200
                height: 100
                color: "pink"
            }
        }

        Component {
            id: supermanagement
            Rectangle {
                width: 200
                height: 100
                color: "black"
            }
        }

        Component {
            id: systemmaintenance
            Rectangle {
                width: 200
                height: 100
                color: "yellow"
            }
        }

        Component {
            id: settings
            Rectangle {
                width: 200
                height: 100
                color: "orange"
            }
        }

        Component {
            id: about
            AboutPage {}
        }

        StackView {
            id: mainstack
            x: menubar.width + 10
            y: topbar.height / 3
            width: root.width - x - 10
            height: root.height - y - 10
            initialItem: globaloverview
            replaceEnter: Transition {
                PropertyAnimation {
                    target: mainstack
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 700
                    easing.type: Easing.InOutElastic
                    easing.amplitude: 2.0
                    easing.period: 1.5
                }
            }
            replaceExit: Transition {
                PropertyAnimation {
                    target: mainstack
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 500
                    easing.type: Easing.InOutElastic
                    easing.amplitude: 2.0
                    easing.period: 1.5
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#c0c0c0";formeditorZoom:0.5;height:1080;width:1920}
}
##^##*/

