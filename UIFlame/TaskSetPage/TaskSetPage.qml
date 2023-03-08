import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtWebEngine
import QtWebChannel
import Service.Taskset 1.0
import Data.Taskset 1.0

// import QtWebEngine
Item {
    id: tasksetpage
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

    TaskSetService {
        id: tasksetservice
    }

    ListModel {
        id: tasklistdata
    }

    Connections {
        target: tasksetservice

        function onTaskSetListChanged(list)
        {
            tasklistdata.clear()
            for (var i = 0; i < list.length; i++) {
                tasklistdata.append(list[i])
            }
        }
    }

    Component.onCompleted: {
        tasksetservice.getTaskSetList()
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
                height: 30
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
                    model: tasklistdata
                    clip: true
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
                        height: 80
                        width: parent.width

                        Rectangle {
                            anchors.fill: parent
                            // 判断是否选中
                            color: tasklist.currentIndex === index ? "#F5F5F5" : "transparent"
                            radius: 10

                            Item {
                                anchors.fill: parent

                                Text {
                                    id: tasksetlistid
                                    y: 10
                                    text: "任务编号：" + tid
                                    color: "#292826"
                                    font.styleName: "Medium"
                                    font.pointSize: 14
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                }

                                Text {
                                    width: 80
                                    text: "地理信息：(" + poslo.toFixed(4) + ", " + posli.toFixed(4) + ")"
                                    color: "#8E99A5"
                                    font.styleName: "Medium"
                                    font.pointSize: 8
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    y: 40
                                }

                                Text {
                                    text: "任务地点: " + area
                                    color: "#8E99A5"
                                    font.styleName: "Medium"
                                    font.pointSize: 8
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    y: 60
                                }

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
            Text {
                text: qsTr("任务总概览")
                height: 30
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
            Text {
                text: qsTr("任务详情")
                height: 30
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
                    id: correnttaskarea

                    width: 400
                    anchors.leftMargin: 10
                    height: parent.height
                    radius: 10
                    color: "white"

                    Text {
                        id: areataskid
                        text: qsTr("任务编号:  ") + tasklistdata.get(tasklist.currentIndex).tid
                        height: 40
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                        anchors.top: parent.top
                        anchors.topMargin: 15
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    Text {
                        id: areataskname
                        text: qsTr("任务名称: ")
                        height: 40
                        anchors.top: areataskid.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    TextField {
                        id: areatasknameinput
                        text: tasklistdata.get(tasklist.currentIndex).name
                        anchors.top: areataskid.bottom
                        anchors.topMargin: 5
                        anchors.left: areataskname.right
                        anchors.leftMargin: 10
                        width: 250
                        height: 45
                        font.pointSize: 14
                    }

                    Text {
                        id: areataskcontent
                        text: qsTr("任务内容: ")
                        height: 160
                        anchors.top: areataskname.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    TextArea{
                        id: areataskcontentinput
                        text: tasklistdata.get(tasklist.currentIndex).content
                        anchors.top: areataskname.bottom
                        anchors.topMargin: 10
                        anchors.left: areataskcontent.right
                        anchors.leftMargin: 10
                        width: 250
                        height: 155
                        font.pointSize: 14
                    }

                    Text {
                        id: areataskarea
                        text: qsTr("任务区域: ")
                        height: 40
                        anchors.top: areataskcontent.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.pointSize: 18
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    TextField {
                        id: areataskareainput
                        text: tasklistdata.get(tasklist.currentIndex).area
                        anchors.top: areataskcontent.bottom
                        anchors.left: areataskarea.right
                        anchors.leftMargin: 10
                        width: 250
                        height: 50
                        font.pointSize: 14
                    }

                    Text {
                        id: areataskstatus
                        text: qsTr("任务状态: ")
                        height: 40
                        anchors.top: areataskarea.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    ComboBox{
                        id: areataskstatusbox
                        model: ["任务下线", "日常执行"]
                        anchors.top: areataskarea.bottom
                        anchors.left: areataskstatus.right
                        anchors.leftMargin: 10
                        width: 140
                        height: 50
                        font.pointSize: 14
                        font.styleName: "Medium"
                        currentIndex:tasklistdata.get(tasklist.currentIndex).state
                    }

                    Text {
                        id: areatasklocation
                        text: qsTr("位置信息:  ") + tasklistdata.get(tasklist.currentIndex).poslo + "\n\t     " + tasklistdata.get(tasklist.currentIndex).posli
                        height: 40
                        anchors.top: areataskstatus.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 18
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

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
                    height: parent.height * 2 / 3 - 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: tasklistarea.right
                    anchors.leftMargin: 10
                    layer.enabled: true

                    Text {
                        id: loadingtext

                        z: 0
                        anchors.centerIn: parent
                        text: "正在载入地图, 请稍后..."
                        font.pixelSize: 30
                        color: "#292826"
                    }

                    Timer {
                        interval: 300
                        running: true
                        repeat: true
                        onTriggered: {
                            if (webview.loading)
                            {
                                if (loadingtext.text === "正在载入地图地图, 请稍后.")
                                {
                                    loadingtext.text = "正在载入地图, 请稍后.."
                                }
                                else if (text.text === "正在载入地图, 请稍后..")
                                {
                                    loadingtext.text = "正在载入地图, 请稍后..."
                                }
                                else
                                    loadingtext.text = "正在载入地图, 请稍后."
                                } else {
                                loadingtext.text = "载入完成"
                            }
                        }
                    }

                    WebEngineView {
                        id: webview
                        anchors.fill: parent
                        anchors.topMargin: 10
                        // url: "qrc:/htmlpage/htmlpage/map.html"
                        QtObject {
                            id: webEngineChannel
                            WebChannel.id: "webChannel"

                            function print(value)
                            {
                                console.log("weboutput:" + value)
                            }
                        }

                        webChannel: WebChannel {
                            registeredObjects: [webEngineChannel]
                        }

                        function enableListener()
                        {
                            webview.runJavaScript("enableLinstener()")
                        }

                        function disableListener()
                        {
                            webview.runJavaScript("disableLinstener()")
                        }

                        function setMapType()
                        {
                            webview.runJavaScript("setMapType()")
                        }
                    }
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

                    height: parent.height / 3 - 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: tasklistarea.right
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
