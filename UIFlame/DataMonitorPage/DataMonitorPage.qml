import Data.Employee 1.0
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Service.Employee 1.0
import Data.Taskset 1.0
import Service.Taskset 1.0
import Data.Attendance 1.0
import Service.Attendance 1.0
import QtWebEngine
import QtWebChannel
import Qt.String 1.0

Item {
    id: taskpage
    // Material主题，蓝色
    Material.theme: Material.Light
    layer.smooth: true

    Component.onCompleted: {
        employeeService.getEmployeeInfoList()
    }

    EmployeeService {
        id: employeeService
    }

    AttendanceService {
        id: attendanceService
    }

    ListModel {
        id: employeedata
    }

    ListModel {
        id: timedata
    }

    ListModel {
        id: attendancedata
    }

    function cycleToString(cycle)
    {
        //"每天", "一周一次", "一周两次", "一周三次", "一周四次", "一周五次", "一周六次", "一月一次", "一月两次"
        switch (cycle) {
            case 0:
            return "每天"
            case 1:
            return "一周一次"
            case 2:
            return "一周两次"
            case 3:
            return "一周三次"
            case 4:
            return "一周四次"
            case 5:
            return "一周五次"
            case 6:
            return "一周六次"
            case 7:
            return "一月一次"
            case 8:
            return "一月两次"
            default:
            return "未知"
        }
    }


    Connections {
        function onEmployeeInfoListChanged()
        {
            employeedata.clear()
            var list = employeeService.employees()
            for (var j = 0; j < list.length; j++) {
                employeedata.append(list[j])
            }
        }
        target: employeeService
    }

    Connections {
        target: attendanceService

        function onAttendanceDayListGet(list)
        {
            // list使用.分割每个日期
            timedata.clear()
            var list = list.split("|")
            for (var i = 0; i < list.length; i++) {
                if (list[i] === "")
                    continue
                timedata.append({"date":list[i]})
            }
        }

        function onAttendanceListGet(list)
        {
            attendancedata.clear()
            for (var i = 0; i < list.length; i++) {
                attendancedata.append(list[i])
            }
        }

        function onAttendanceDetailGet(data)
        {
            webview.reload()
            console.log(data);
        }
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
            text: qsTr("数据监控")
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
                                attendanceService.getAttendanceDayList(employid)
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
                        Text {
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
                        Text {
                            text: qsTr("搜索")
                            color: "white"
                            anchors.centerIn: parent
                            font.pointSize: 14
                        }
                        onClicked: {
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
                    id: currenttimesessionarea

                    width: 400
                    anchors.leftMargin: 10
                    height: parent.height
                    radius: 10
                    ListView {
                        id: currentemployeetasklist

                        anchors.fill: parent
                        model: timedata
                        spacing: 10
                        delegate: Rectangle {
                            id: currentemployeetaskitem

                            width: parent.width
                            height: 75
                            radius: 10
                            layer.enabled: true
                            color: currentemployeetasklist.currentIndex === index ? "#F5F5F5" : "transparent"
                            layer.effect: DropShadow {
                                cached: true
                                color: "#90849292"
                                horizontalOffset: 3
                                verticalOffset: 3
                                radius: 10
                                samples: 2 * radius + 1
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 10
                                text: "任务时间"
                            }

                            Text {
                                id: currenttime
                                anchors.left: parent.left
                                anchors.leftMargin: 30
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 15
                                text: date
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 15
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

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    currentemployeetasklist.currentIndex = index
                                    attendanceService.getAttendanceList(employeedata.get(employeelist.currentIndex).employid, date)
                                }
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

                    height: parent.height *0.52 - 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: currenttimesessionarea.right
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
                    url: "qrc:/htmlpage/htmlpage/monitor.html"
                    QtObject {
                        id: webEngineChannel
                        WebChannel.id: "webChannel"

                        function sprint(value)
                        {
                            console.log("weboutput:" + value)
                        }
                    }

                    webChannel: WebChannel {
                        registeredObjects: [webEngineChannel]
                    }

                    function clear()
                    {
                        webview.runJavaScript("clear()")
                    }

                    function replay()
                    {
                        webview.runJavaScript("start()")
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
            Text {
                id: tasklisttitle

                anchors.top: maparea.bottom
                anchors.topMargin: 5
                anchors.left: maparea.left
                anchors.leftMargin: 10
                text: qsTr("任务列表")
                color: "#949494"
                font.styleName: "Medium"
                font.pointSize: 16
            }
            // 右侧显示全部任务列表按钮和显示全部任务坐标按钮
            Button {
                id: replaybutton

                width: 150
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.top: tasklisttitle.top
                background: Rectangle {
                    color: "#4A90E2"
                    radius: 5
                }
                Text {
                    text: qsTr("重播")
                    color: "white"
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
                onClicked: {
                    webview.clear()
                    webview.replay()
                }
            }

            // 可观看任务列表
            Rectangle {
                id: tasklistarea

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: currenttimesessionarea.right
                anchors.leftMargin: 10
                anchors.top: maparea.bottom
                anchors.topMargin: 45
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                ListView {
                    id: tasklist

                    anchors.fill: parent
                    model: attendancedata
                    spacing: 10
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
                    delegate: Rectangle {
                        id: tasklistitem

                        width: parent.width
                        height: 120
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

                        // 任务编号
                        Text {
                            id: taskidtext

                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.top: parent.top
                            anchors.topMargin: 15
                            text: qsTr("任务编号: ") + tid
                            color: "#949494"
                            font.styleName: "Medium"
                            font.pointSize: 14
                        }

                        // 开始时间
                        Text {
                            id: starttimetext

                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.top: taskidtext.bottom
                            anchors.topMargin: 5
                            text: qsTr("开始时间: ") + startTime
                            color: "#949494"
                            font.styleName: "Medium"
                            font.pointSize: 10
                        }

                        // 结束时间
                        Text {
                            id: endtimetext

                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.top: starttimetext.bottom
                            anchors.topMargin: 5
                            text: qsTr("结束时间: ") + endTime
                            color: "#949494"
                            font.styleName: "Medium"
                            font.pointSize: 10
                        }

                        // 任务状态
                        Text {
                            id: taskstatustext

                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.top: endtimetext.bottom
                            anchors.topMargin: 5
                            text: qsTr("任务状态: ") + taskCompletion
                            color: "#949494"
                            font.styleName: "Medium"
                            font.pointSize: 10
                        }


                        Button {
                            id: viewcurrenttaskbtn
                            width: 100
                            height: 50
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                color: "#28D33F"
                                radius: 5
                            }
                            Text {
                                text: qsTr("查看")
                                color: "white"
                                anchors.centerIn: parent
                                font.pointSize: 14
                            }
                            onClicked: {
                                console.log("info", employid, tid, startTime);
                                attendanceService.getAttendanceDetail(employid, tid, startTime)
                            }
                        }
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
    }
}
}

