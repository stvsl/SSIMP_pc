
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Window {
    visible: true
    width: 640
    height: 380
    id: loadpage
    title: qsTr("北镇闾山景区巡查监测平台守护程序")
    flags: Qt.FramelessWindowHint

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/daemon/daemon/background.jpg"
        asynchronous: true
        autoTransform: true
        mipmap: true
        scale: 1
        baselineOffset: 0
        smooth: true

        Repeater {
            model: 5
            id: repeater
            Rectangle {
                property real radius1: 25
                property real dx: 45 //圆心坐标
                property real dy: loadpage.height - 50
                property real cx: radius1 * Math.sin(
                                      percent * 6.283185307179) + dx //各个圆点的实时坐标
                property real cy: radius1 * Math.cos(
                                      percent * 6.283185307179) + dy
                property real percent: 2
                id: dot
                width: 8
                height: 8
                radius: 25
                color: Qt.rgba(1, 1, 1, 1)
                opacity: 0
                smooth: true
                x: cx
                y: cy

                SequentialAnimation on percent {
                    PauseAnimation {
                        duration: 225 * index
                    }
                    loops: Animation.Infinite
                    running: true
                    ParallelAnimation {
                        NumberAnimation {
                            target: dot
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 225
                        }
                        NumberAnimation {
                            duration: 225
                            from: 1 + index * 0.05
                            to: 0.75
                        }
                    }

                    NumberAnimation {
                        duration: 60
                        from: 0.75
                        to: 0.7
                    }
                    NumberAnimation {
                        duration: 140
                        from: 0.7
                        to: 0.65
                    }
                    NumberAnimation {
                        duration: 160
                        from: 0.65
                        to: 0.6
                    }

                    NumberAnimation {
                        duration: 225
                        from: 0.6
                        to: 0.55
                    }
                    NumberAnimation {
                        duration: 225
                        from: 0.55
                        to: 0.5
                    }

                    NumberAnimation {
                        duration: 225
                        from: 0.5
                        to: 0.45
                    }
                    NumberAnimation {
                        duration: 225
                        from: 0.45
                        to: 0.4
                    }
                    NumberAnimation {
                        duration: 50
                        from: 0.4
                        to: 0.35
                    }
                    NumberAnimation {
                        duration: 30
                        from: 0.35
                        to: 0.3
                    }
                    NumberAnimation {
                        duration: 180
                        from: 0.3
                        to: 0
                    }
                    NumberAnimation {
                        duration: 225
                        from: 1
                        to: 0.75
                    }

                    NumberAnimation {
                        duration: 60
                        from: 0.75
                        to: 0.7
                    }
                    NumberAnimation {
                        duration: 140
                        from: 0.7
                        to: 0.65
                    }
                    NumberAnimation {
                        duration: 160
                        from: 0.65
                        to: 0.6
                    }

                    NumberAnimation {
                        duration: 225
                        from: 0.6
                        to: 0.55
                    }
                    NumberAnimation {
                        duration: 225
                        from: 0.55
                        to: 0.5
                    }
                    NumberAnimation {
                        duration: 225
                        from: 0.5
                        to: 0.45
                    }
                    NumberAnimation {
                        duration: 225
                        from: 0.45
                        to: 0.4
                    }
                    NumberAnimation {
                        duration: 50
                        from: 0.4
                        to: 0.35
                    }
                    NumberAnimation {
                        duration: 30
                        from: 0.35
                        to: 0.3
                    }
                    NumberAnimation {
                        duration: 180
                        from: 0.3
                        to: 0
                    }
                    NumberAnimation {
                        target: dot
                        duration: 50
                        property: "opacity"
                        from: 1
                        to: 0
                    }

                    PauseAnimation {
                        duration: (repeater.count - index - 1) * 225
                    }
                }
            }
        }

        Label {
            id: process
            x: 38
            y: loadpage.height - 54
            // 定义全局变量，用于记录当前进度
            property int progress: 0
            text: qsTr(progress + "%")
            color: Qt.rgba(1, 1, 1, 0.5)
            Timer {
                id: timer
                interval: 100
                running: true
                repeat: true
                onTriggered: {
                    process.progress += 5
                    process.text = qsTr(process.progress + "%")
                    if (process.progress == 10) {
                        process.x = 35
                    }
                    if (process.progress >= 100) {
                        process.x = 31
                        timer.stop()
                        daemon.switchtoLogin()
                    }
                }
            }
        }

        Label {
            id: status
            text: qsTr("正在加载中...")
            x: process.x + process.width + 370
            y: loadpage.height - 54
            color: Qt.rgba(1, 1, 1, 0.5)
        }
        Label {
            id: label
            text: qsTr("北镇闾山景区巡查监测平台")
            verticalAlignment: Text.AlignVCenter
            font.strikeout: false
            font.wordSpacing: -1.3
            font.family: "Courier"
            font.weight: Font.Light
            font.bold: false
            font.italic: true
            font.pointSize: 30
            x: 39
            y: 52
            width: 497
            height: 59
            color: "#000000"
        }
        Label {
            id: info
            x: label.x + label.width - 180
            y: label.y + 50
            color: "#be000000"
            text: qsTr("V 0.0.1 Develop, powered by stvsl&jl")
            horizontalAlignment: Text.AlignLeft
            clip: true
            font.italic: true
            font.family: "Tahoma"
        }

        Button {
            id: button
            x: 607
            y: 0
            width: 33
            height: 29
            text: qsTr("X")
            layer.smooth: true
            transformOrigin: Item.TopRight
            font.styleName: "Medium"
            clip: true
            focusPolicy: Qt.NoFocus
            layer.enabled: true
            antialiasing: true
            focus: true
            wheelEnabled: true
            autoRepeat: false
            autoExclusive: false
            checkable: true
            flat: true
            onClicked: {
                loadpage.close()
                daemon.close()
                Qt.quit()
            }
        }
    }
}
