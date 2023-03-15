import Data.Employee 1.0
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Service.Employee 1.0
import Data.Task 1.0
import Service.Task 1.0
import Data.Taskset 1.0
import Service.Taskset 1.0
import QtWebEngine
import QtWebChannel

Item {
    id: taskpage
    // Material主题，蓝色
    Material.theme: Material.Light
    layer.smooth: true

    Component.onCompleted: {
        employeeService.getEmployeeInfoList()
        tasksetService.getTaskSetList()
    }

    EmployeeService {
        id: employeeService
    }

    TaskService {
        id: taskService
    }

    TaskSetService {
        id: tasksetService
    }

    ListModel {
        id: employeedata
    }

    ListModel {
        id: employeetasksetdata
    }

    Connections {
        function onEmployeeInfoListChanged()
        {
            employeedata.clear()
            for (var j = 0; j < employeeService.employees().length; j++) {
                var employe = employeeService.employees()[j]
                employeedata.append(employe)
            }
        }
        target: employeeService
    }

    Connections{
        function onEmployeeTaskListChanged(list)
        {
            if (employeetasksetdata.count > 0)
            {
                employeetasksetdata.clear()
            }
            for (var i = 0; i < list.length; i++) {
                employeetasksetdata.append(list[i])
            }
        }
        target: taskService
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
            text: qsTr("任务委派")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        // 左侧员工列表以及配套工具区域
        Rectangle {
            id: leftarea

            width: 300
            height: parent.height - 50
            layer.enabled: true
            radius: 10

            ListView {
                id: employeelist

                anchors.fill: parent
                anchors.margins: 8
                anchors.bottomMargin: 150
                spacing: 3
                model: employeedata
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
                                employeelist.currentIndex = index
                                taskService.getTaskListByEid(employid)
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

                            Image {
                                id: listimage

                                source: "qrc:/icon/EmployeePage/icon/EmployeePage/缺勤率完成率.png"
                                width: 50
                                height: 50
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                            }

                            Text {
                                id: listname

                                y: 10
                                text: name
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 15
                                anchors.left: listimage.right
                                anchors.leftMargin: 15
                            }

                            Text {
                                id: listemployid

                                text: "eid " + employid
                                color: "#8E99A5"
                                font.styleName: "Medium"
                                font.pointSize: 10
                                anchors.left: listimage.right
                                anchors.bottom: listimage.bottom
                                anchors.leftMargin: 15
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
                    }
                }
            }

            // 分界线
            Rectangle {
                width: parent.width*0.8
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:employeelist.bottom
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
                anchors.top: employeelist.bottom
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
                        id:employeesearchtext
                        width: parent.width *0.6
                        height: 40
                        placeholderText: qsTr("输入员工姓名以搜索")
                        font.pointSize: 12
                    }

                    Button {
                        id: employeesearchbutton
                        width: parent.width *0.3
                        height: 40
                        font.pointSize: 15
                        background: Rectangle {
                            color: "#4A90E2"
                            radius: 5
                        }
                        Text{
                            text: qsTr("搜索")
                            color: "white"
                            anchors.centerIn: parent
                            font.pointSize: 14
                        }
                    }

                    TextField {
                        id: tasksearchtext
                        width: parent.width *0.6
                        height: 40
                        placeholderText: qsTr("输入任务名称以搜索")
                        font.pointSize: 12
                    }

                    Button {
                        id: tasksearchbutton
                        width: parent.width *0.3
                        height: 40
                        font.pointSize: 15
                        background: Rectangle {
                            color: "#4A90E2"
                            radius: 5
                        }
                        Text{
                            text: qsTr("搜索")
                            color: "white"
                            anchors.centerIn: parent
                            font.pointSize: 14
                        }
                    }

                    Text{
                        text: qsTr("排序方式")
                        color: "#535060"
                        height: 40
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Medium
                    }
                    // 升降序
                    Switch {
                        id: employeesortswitch
                        width: 130
                        height: 40
                        checked: false
                        text: checked?qsTr("升序排序"):qsTr("降序排序")
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

                Rectangle {
                    id: currentemployeetaskarea

                    width: 400
                    anchors.leftMargin: 10
                    height: parent.height
                    radius: 10
                    ListView {
                        id: currentemployeetasklist

                        anchors.fill: parent
                        model: employeetasksetdata
                        delegate: Rectangle {
                            id: currentemployeetaskitem

                            width: parent.width
                            height: 50
                            color: "red"
                            radius: 10
                            layer.enabled: true
                            layer.effect: DropShadow {
                                cached: true
                                color: "#90849292"
                                horizontalOffset: 3
                                verticalOffset: 3
                                radius: 10
                                samples: 2 * radius + 1
                            }

                            Text {
                                id: currentemployeetaskname

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                text: name
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 15
                            }

                            Text {
                                id: currentemployeetaskstatus

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                text: status
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 15
                            }
                        }
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

                    height: parent.height *0.6 - 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: currentemployeetaskarea.right
                    anchors.leftMargin: 10
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
                                if (loadingtext.text == "正在载入地图, 请稍后...")
                                {
                                    loadingtext.text = "正在载入地图, 请稍后."
                                }
                            } else {
                            loadingtext.text = "载入完成"
                            stop()
                        }
                    }
                }

                WebEngineView {
                    id: webview
                    anchors.fill: parent
                    anchors.topMargin: 10
                    url: "qrc:/htmlpage/htmlpage/map.html"
                    // 允许跨域
                    QtObject {
                        id: webEngineChannel
                        WebChannel.id: "webChannel"

                        function print(value)
                        {
                            console.log("weboutput:" + value)
                        }

                        function receiveLocateInfo(info, x, y)
                        {
                            console.log("weboutput:" + info + " " + x + " " + y)
                            tasklistdata.setProperty(tasklist.currentIndex,
                            "poslo", x)
                            tasklistdata.setProperty(tasklist.currentIndex,
                            "posli", y)
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

                    function addPoint(name, x, y)
                    {
                        webview.runJavaScript(
                            "addPoint('" + name + "', " + x + ", " + y + ")")
                        }

                        function removeAllPoint()
                        {
                            webview.runJavaScript("removePoint()")
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

                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: currentemployeetaskarea.right
                    anchors.leftMargin: 10
                    anchors.top: maparea.bottom
                    anchors.topMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
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
