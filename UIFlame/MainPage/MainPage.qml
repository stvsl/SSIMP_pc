/*##^##
Designer {
    D {i:0;formeditorColor:"#c0c0c0";formeditorZoom:0.5;height:1080;width:1920}
}
##^##*/

import "../AboutPage"
import "../ContentMgrPage"
import "../EmployeePage"
import "../LsKyPage"
import "../Menu"
import "../TaskPage"
import "../TaskSetPage"
import "../GlobalOverviewPage"
import "../DataMonitorPage"
import "../FeedbackPage"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: root

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("北镇闾山景区巡查监测平台")
    onClosing: {
        root.close();
        daemon.close();
        Qt.quit();
    }

    Rectangle {
        anchors.fill: parent
        color: "#fbfcfe"
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
        width: menubar.width
        height: 70
        border.width: 0
        smooth: true

        Rectangle {
            z: 1
            anchors.verticalCenter: topbar.verticalCenter
            anchors.left: parent.left
            visible: true
            height: 70
            width: 300

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(width, height)

                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#005be0"
                    }

                    GradientStop {
                        position: 1
                        color: "#00c6fb"
                    }

                }

            }

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
                height: 800
                boundsMovement: Flickable.StopAtBounds
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        Component {
            id: globaloverview

            GlobalOverviewPage {
            }

        }

        Component {
            id: datamonitoring
            DataMonitorPage {
            }
        }

        Component {
            id:exceptionfeedback
            FeedbackPage {
            }
        }

        Component {
            id: staffmanagement

            EmployeePage {
            }

        }

        Component {
            id: worktask

            TaskPage {
            }

        }

        Component {
            id: contentmanagement

            ContentMgrPage {
            }

        }

        Component {
            id: lskymanagement

            LsKyPage {
            }

        }

        Component {
            id: taskset

            TaskSetPage {
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

            AboutPage {
            }

        }

        StackView {
            id: mainstack

            x: menubar.width + 20
            y: 5
            width: root.width - x - 20
            height: root.height - y - 10
            initialItem: globaloverview

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0.3
                    to: 1
                    duration: 100
                }

            }

            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0.3
                    duration: 100
                }

            }

            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0.3
                    to: 1
                    duration: 100
                }

            }

            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0.3
                    duration: 100
                }

            }

        }

    }

}
