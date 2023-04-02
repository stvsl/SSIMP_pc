import QtQuick 2.15

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    id: taskpage
    // Material主题，蓝色
    Material.theme: Material.Light
    layer.smooth: true

    Component.onCompleted: {

    }

    ListModel {
        id: feedbackdata
    }

    Flow {
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
            text: qsTr("异常反馈")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        Rectangle {
            id: leftarea

            width: 300
            height: parent.height - 50
            layer.enabled: true
            radius: 10

            ListView {
                id: feedbacklist
                anchors.fill: parent
                anchors.margins: 8
                anchors.bottomMargin: 150
                spacing: 3

                model: feedbackdata
                onOpacityChanged: {
                    if (opacity === 0)
                        listView.currentIndex = index
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
                }

                delegate: Item {
                    height: 70
                    width: parent.width

                    Rectangle {
                        anchors.fill: parent
                        // 判断是否选中
                        color: feedbacklist.currentIndex === index ? "#F5F5F5" : "transparent"
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
                            anchors.bottom: parent.bottom

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

                        Item {
                            anchors.fill: parent

                            Text {
                                text: "显示详情 >"
                                color: "#AA8E99A5"
                                font.styleName: "Medium"
                                font.pointSize: 10
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }

            // 分界线
            Rectangle {
                width: parent.width * 0.8
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: feedbacklist.bottom
                anchors.topMargin: 5
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

            // 功能区
            Rectangle {
                id: functionarea
                width: parent.width
                anchors.top: feedbacklist.bottom
                anchors.topMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                radius: 10

                Flow {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.bottomMargin: 0
                    spacing: 5

                    TextField {
                        id: feedbacksearchtext
                        width: parent.width * 0.6
                        height: 40
                        placeholderText: qsTr("输入员工姓名以搜索")
                        font.pointSize: 12
                    }

                    Button {
                        id: feedbacksearchbutton
                        width: parent.width * 0.3
                        height: 40
                        font.pointSize: 15
                        background: Rectangle {
                            color: "#4A90E2"
                            radius: 5
                        }
                        Text {
                            text: qsTr("搜索")
                            color: "white"
                            anchors.centerIn: parent
                            font.pointSize: 14
                        }
                    }

                    TextField {
                        id: tasksearchtext
                        width: parent.width * 0.6
                        height: 40
                        placeholderText: qsTr("输入任务名称以搜索")
                        font.pointSize: 12
                    }

                    Button {
                        id: tasksearchbutton
                        width: parent.width * 0.3
                        height: 40
                        font.pointSize: 15
                        background: Rectangle {
                            color: "#4A90E2"
                            radius: 5
                        }
                        Text {
                            text: qsTr("搜索")
                            color: "white"
                            anchors.centerIn: parent
                            font.pointSize: 14
                        }
                        onClicked: {
                            tasksetService.searchTaskSet(tasksearchtext.text)
                        }
                    }

                    Text {
                        text: qsTr("排序方式")
                        color: "#535060"
                        height: 40
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Medium
                    }
                    // 升降序
                    Switch {
                        id: feedbacksortswitch
                        width: 130
                        height: 40
                        checked: false
                        text: checked ? qsTr("升序排序") : qsTr("降序排序")
                    }
                }
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

        Rectangle {
            id: rightarea

            width: parent.width - leftarea.width - 20
            height: leftarea.height
            radius: 10

            Rectangle {
                id: mainarea
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                layer.enabled: true
                color: "white"
                radius: 10
            }
        }
    }
}
