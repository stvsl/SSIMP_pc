import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

// import QtWebEngine
Item {
    id: tasksetpage

    // Material主题，蓝色
    Material.theme: Material.Light
    layer.smooth: true

    Timer {
        id: timer

        interval: 100
        running: true
        repeat: false
        onTriggered: {

        }
    }

    Flow {
        // 当前可用任务列表

        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 0
        layer.smooth: true
        antialiasing: true
        spacing: 15

        Text {
            width: parent.width
            height: 40
            color: "#8E99A5"
            text: qsTr("任务设置")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        Rectangle {
            id: leftarea

            width: 350
            height: parent.height - 50
            color: "transparent"

            Text {
                width: parent.width
                text: qsTr("当前可用任务列表")
                height: 25
                color: "#8E99A5"
                font.styleName: "Medium"
                font.pointSize: 18
            }

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 35
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                layer.enabled: true
                radius: 10
                clip: true

                layer.effect: DropShadow {
                    cached: true
                    color: "#90849292"
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 10
                    samples: 2 * radius + 1
                }

                ListView {
                    id: tasklist

                    anchors.fill: parent
                    anchors.margins: 8
                    anchors.bottomMargin: 300
                    spacing: 3
                    // model:
                    onOpacityChanged: {
                        if (opacity === 0)
                            listView.currentIndex = index;

                    }

                    populate: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 200
                        }

                    }

                    add: Transition {
                        ParallelAnimation {
                            NumberAnimation {
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 200
                            }

                            NumberAnimation {
                                property: "y"
                                from: 0
                                duration: 200
                            }

                        }

                    }

                    displaced: Transition {
                        SpringAnimation {
                            property: "y"
                            spring: 3
                            damping: 0.1
                            epsilon: 0.25
                        }

                    }

                    remove: Transition {
                        SequentialAnimation {
                            NumberAnimation {
                                property: "y"
                                to: 0
                                duration: 120
                            }

                            NumberAnimation {
                                property: "opacity"
                                to: 0
                                duration: 120
                            }

                        }
                        //remove Transition is end

                    }

                    delegate: Item {
                        height: 70
                        width: parent.width

                        Rectangle {
                            anchors.fill: parent
                            // 判断是否选中
                            color: employeelist.currentIndex === index ? "#F5F5F5" : "transparent"
                            radius: 10

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                }
                            }

                            // 底部分割线
                            Rectangle {
                                width: parent.width / 1.2
                                height: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottomk

                                gradient: Gradient {
                                    GradientStop {
                                        position: 0
                                        color: "#FFFFFF"
                                    }

                                    GradientStop {
                                        position: 0.5
                                        color: "#EEEEEE"
                                    }

                                    GradientStop {
                                        position: 1
                                        color: "#FFFFFF"
                                    }

                                }

                            }

                        }

                    }

                }

                // 功能区
                Rectangle {
                    id: functionarea

                    width: parent.width
                    height: 150
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    color: "#F5F5F5"
                    radius: 10
                }

            }





        }

        Rectangle {
            id: rightarea

            width: parent.width - leftarea.width - 20
            height: leftarea.height
            radius: 10
            // 任务概览
            Text{
                text: qsTr("任务总概览")
                height: 25
                color: "#8E99A5"
                font.styleName: "Medium"
                font.pointSize: 18
            }

            Rectangle {
                id: overviewarea

                width: parent.width
                height: 150
                radius: 10
                anchors.top: parent.top
                anchors.topMargin: 35
                layer.enabled: true
                color: "white"

                layer.effect: DropShadow {
                    cached: true
                    color: "#90849292"
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 10
                    samples: 2 * radius + 1
                }

            }

            // 任务详情
            Text{
                text: qsTr("任务详情")
                height: 25
                anchors.top: overviewarea.bottom
                anchors.topMargin: 10
                color: "#8E99A5"
                font.styleName: "Medium"
                font.pointSize: 18
            }

            Rectangle {
                id: mainarea

                width: parent.width
                anchors.top: overviewarea.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 50
                layer.enabled: true
                color: "white"
                radius: 10

                Rectangle {
                    id: currentemployeetaskarea

                    width: 400
                    anchors.leftMargin: 10
                    height: parent.height
                    radius: 10
                    color: "white"

                    // 边框右边线条
                    Rectangle {
                        width: 1
                        height: parent.height / 1.2
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        color: "#EEEEEE"
                    }

                }
                // 地图导航

                Rectangle {
                    id: maparea

                    height: parent.height / 2 - 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: currentemployeetaskarea.right
                    anchors.leftMargin: 10
                    layer.enabled: true
                }

                // 分割线
                Rectangle {
                    width: maparea.width / 1.2
                    //  相对于maparea水平居中
                    anchors.horizontalCenter: maparea.horizontalCenter
                    height: 1
                    anchors.top: maparea.bottom
                    anchors.topMargin: 5
                    color: "#EEEEEE"
                }

                // 区域可选任务列表
                Rectangle {
                    id: tasklistarea

                    height: parent.height / 2 - 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: currentemployeetaskarea.right
                    anchors.leftMargin: 10
                    anchors.top: maparea.bottom
                    anchors.topMargin: 10
                }

                layer.effect: DropShadow {
                    cached: true
                    color: "#90849292"
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 10
                    samples: 2 * radius + 1
                }

            }

        }

    }

}
