import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: emlpoyeepage

    layer.smooth: true
    width: parent.width
    height: parent.height

    Flow {
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 0
        layer.smooth: true
        antialiasing: true
        spacing: 15

        Text {
            width: 300
            height: 40
            color: "#8E99A5"
            text: qsTr("员工信息")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        Row {
            width: parent.width - 50
            height: 130
            rightPadding: 35
            layoutDirection: Qt.LeftToRight
            spacing: 35

            Rectangle {
                width: 1
                height: 130
                color: "transparent"
            }

            Rectangle {
                id: topinfobar

                width: 300
                height: 130
                clip: true
                radius: 15
                layer.enabled: true

                Row {
                    anchors.fill: parent
                    anchors.margins: 10

                    Column {
                        height: parent.height

                        Row {
                            x: 20
                            width: 150
                            height: 50

                            Text {
                                width: 90
                                height: 40
                                text: qsTr("员工总数:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignBottom
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            Text {
                                text: "0"
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                width: 50
                                height: 50
                                font.styleName: "Medium"
                                font.pointSize: 18
                                color: "#082342"
                            }

                        }

                        Row {
                            x: 20
                            width: 150
                            height: 50

                            Text {
                                width: 90
                                height: 40
                                text: qsTr("工作人数:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignBottom
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            Text {
                                text: "0"
                                verticalAlignment: Text.AlignVCenter
                                width: 50
                                height: 50
                                font.styleName: "Medium"
                                font.pointSize: 18
                                color: "#082342"
                            }

                        }

                    }

                    Rectangle {
                        width: 120
                        height: parent.height

                        Image {
                            source: "qrc:/icon/AboutPage/icon/AboutPage/关于我们.png"
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            width: 75
                            height: 75
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
                id: topinfobar2

                radius: topinfobar.radius
                width: topinfobar.width
                height: topinfobar.height
                clip: topinfobar.clip
                layer.enabled: topinfobar.layer.enabled
                layer.effect: topinfobar.layer.effect

                Row {
                    anchors.fill: parent
                    anchors.margins: 10

                    Column {
                        height: parent.height

                        Row {
                            x: 20
                            width: 150
                            height: 50

                            Text {
                                width: 90
                                height: 40
                                text: qsTr("今日已打卡:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignBottom
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            Text {
                                text: "0"
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                width: 50
                                height: 50
                                font.styleName: "Medium"
                                font.pointSize: 18
                                color: "#082342"
                            }

                        }

                        Row {
                            x: 20
                            width: 150
                            height: 50

                            Text {
                                width: 90
                                height: 40
                                text: qsTr("今日已签退:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignBottom
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            Text {
                                text: "0"
                                verticalAlignment: Text.AlignVCenter
                                width: 50
                                height: 50
                                font.styleName: "Medium"
                                font.pointSize: 18
                                color: "#082342"
                            }

                        }

                    }

                    Rectangle {
                        width: 120
                        height: parent.height

                        Image {
                            source: "qrc:/icon/AboutPage/icon/AboutPage/关于我们.png"
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            width: 75
                            height: 75
                        }

                    }

                }

            }

            Rectangle {
                id: topinfobar3

                radius: topinfobar.radius
                width: topinfobar.width
                height: topinfobar.height
                clip: topinfobar.clip
                layer.enabled: topinfobar.layer.enabled
                layer.effect: topinfobar.layer.effect

                Row {
                    anchors.fill: parent
                    anchors.margins: 10

                    Column {
                        height: parent.height

                        Row {
                            x: 20
                            width: 150
                            height: 50

                            Text {
                                width: 90
                                height: 40
                                text: qsTr("缺勤率:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignBottom
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            Text {
                                text: "0"
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                width: 50
                                height: 50
                                font.styleName: "Medium"
                                font.pointSize: 18
                                color: "#082342"
                            }

                        }

                        Row {
                            x: 20
                            width: 150
                            height: 50

                            Text {
                                width: 90
                                height: 40
                                text: qsTr("工作完成率:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignBottom
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            Text {
                                text: "0"
                                verticalAlignment: Text.AlignVCenter
                                width: 50
                                height: 50
                                font.styleName: "Medium"
                                font.pointSize: 18
                                color: "#082342"
                            }

                        }

                    }

                    Rectangle {
                        width: 120
                        height: parent.height

                        Image {
                            source: "qrc:/icon/AboutPage/icon/AboutPage/关于我们.png"
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            width: 75
                            height: 75
                        }

                    }

                }

            }

            Rectangle {
                id: topinfobar4

                width: parent.width - topinfobar.width * 3 - parent.spacing * 4
                height: topinfobar.height
                radius: topinfobar.radius
                clip: topinfobar.clip
                layer.enabled: topinfobar.layer.enabled
                layer.effect: topinfobar.layer.effect
            }

        }

        Rectangle {
            width: leftbar.width
            height: 25

            Row {
                Text {
                    text: qsTr("员工列表")
                    color: "#8E99A5"
                    font.styleName: "Medium"
                    font.pointSize: 18
                }

                Switch {
                    id: upordown

                    width: 35
                    height: 35
                    scale: 0.598
                    //        rotation: 90
                    layer.smooth: true
                }

                Text {
                    width: 35
                    height: parent.height
                    text: upordown.checked ? qsTr("1") : qsTr("2")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                }

            }

        }

        Text {
            text: qsTr("详细信息")
            width: mainstack.width
            height: 25
            color: "#8E99A5"
            font.styleName: "Medium"
            font.pointSize: 18
        }

        Rectangle {
            id: leftbar

            radius: 10
            width: parent.width / 4
            height: parent.height - topinfobar.height - 110
            layer.enabled: true

            layer.effect: DropShadow {
                cached: true
                color: "#90849292"
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                samples: 2 * radius + 1
            }

        }

        Rectangle {
            id: mainstack

            width: parent.width - leftbar.width - 20
            height: leftbar.height
            radius: 10
            layer.enabled: true

            Flow {
                id: grid
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                Row {
                    width: 400
                    // 用户ID
                    Text {
                        text: qsTr("用户ID:")
                        width: 100
                        height: 25
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                    }

                    Text {
                        text: qsTr("123456")
                        width: 100
                        height: 25
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                    }

                }
                Row {
                    // 用户ID
                    width: 400
                    height: 800
                    Text {
                        text: qsTr("用户ID:")
                        width: 100
                        height: 25
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                    }

                    Text {
                        text: qsTr("123456")
                        width: 100
                        height: 25
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                    }

                }


            }

            layer.effect: DropShadow {
                cached: true
                color: "#90849292"
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                samples: 2 * radius + 1
            }

        }

    }

}
