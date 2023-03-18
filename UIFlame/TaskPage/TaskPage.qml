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
        timer.start()
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

    ListModel {
        id: tasksetdata
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

    function isNotInEmployeeTaskList(id)
    {
        for (var i = 0; i < employeetasksetdata.count; i++) {
            if (employeetasksetdata.get(i).tid === id)
            {
                return false
            }
        }
        return true
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

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            taskService.getTaskListByEid(employeedata.get(0).employid)
        }
    }

    Connections {
        target: tasksetService

        function onTaskSetListChanged(list)
        {
            if (tasksetdata.count > 0)
            {
                tasksetdata.clear()
            }
            for (var i = 0; i < list.length; i++) {
                tasksetdata.append(list[i])
            }
        }
    }

    Connections {
        function onEmployeeTaskListChanged(list)
        {
            if (employeetasksetdata.count > 0)
            {
                employeetasksetdata.clear()
            }
            for (var i = 0; i < list.length; i++) {
                employeetasksetdata.append(list[i])
            }
            webview.showCurrentPoint(list)

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
                        spacing: 10
                        delegate: Rectangle {
                            id: currentemployeetaskitem

                            width: parent.width
                            height: 150
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
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top:parent.top
                                anchors.topMargin: 10
                                text: name
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 15
                            }

                            Text {
                                id: currentemployeetaskcontent

                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top:currentemployeetaskname.bottom
                                anchors.topMargin: 10
                                text: content
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 13
                            }
                            Text {
                                id: currentemployeetaskarea

                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
                                text:qsTr("时长")+duration + qsTr("小时")
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 13
                            }

                            // 在时长的后面显示周期
                            Text {
                                id: currentemployeetaskcycle

                                anchors.left: currentemployeetaskarea.right
                                anchors.leftMargin: 10
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
                                text: qsTr("任务周期:") + cycleToString(cycle)
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 13
                            }

                            // 右下角取消任务按钮
                            Button {
                                id: currentemployeetaskcancelbutton

                                width: 100
                                height: 50
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 5
                                background: Rectangle {
                                    color: "#FF516B"
                                    radius: 5
                                }
                                Text {
                                    text: qsTr("取消委派")
                                    color: "white"
                                    anchors.centerIn: parent
                                    font.pointSize: 14
                                }
                                onClicked: {
                                    taskService.deleteTask(employeedata.get(employeelist.currentIndex).employid, tid)
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
                            webview.showAllPoint()
                            stop()
                        }
                    }
                }

                WebEngineView {
                    id: webview
                    anchors.fill: parent
                    anchors.topMargin: 10
                    url: "qrc:/htmlpage/htmlpage/map.html"
                    QtObject {
                        id: webEngineChannel
                        WebChannel.id: "webChannel"

                        function sprint(value)
                        {
                            console.log("weboutput:" + value)
                        }

                        function nowIs(name, x, y)
                        {
                            tasksetService.tasksets(name, x, y)
                        }

                    }

                    function receiveLocateInfo(info, x, y)
                    {
                        console.log("weboutput:" + info + " " + x + " " + y)
                        tasklistdata.setProperty(tasklist.currentIndex,
                        "poslo", x)
                        tasklistdata.setProperty(tasklist.currentIndex,
                        "posli", y)
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
                        webview.runJavaScript("addPoint('" + name + "', " + x + ", " + y + ")")
                    }

                    function removeAllPoint()
                    {
                        webview.runJavaScript("removePoint()")
                    }
                    function showAllPoint()
                    {
                        webview.removeAllPoint()
                        var tasksets = tasksetService.tasksets();
                        for (var i = 0; i < tasksets.length; i++)
                        {
                            var taskset = tasksets[i];
                            webview.addPoint(taskset.name, taskset.poslo, taskset.posli);
                        }
                    }
                    function showCurrentPoint(list)
                    {
                        webview.removeAllPoint();
                        for (var i = 0; i < list.length; i++)
                        {
                            var taskset = list[i];
                            webview.addPoint(taskset.name, taskset.poslo, taskset.posli);
                        }

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
                text: qsTr("可用任务列表")
                color: "#949494"
                font.styleName: "Medium"
                font.pointSize: 16
            }
            // 右侧显示全部任务列表按钮和显示全部任务坐标按钮
            Button {
                id: showalltaskposbutton

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
                    text: qsTr("显示全部任务坐标")
                    color: "white"
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
                onClicked: {
                    webview.showAllPoint()
                }
            }
            Button {
                id: showalltaskbutton

                width: 110
                height: 40
                anchors.right: showalltaskposbutton.left
                anchors.rightMargin: 10
                anchors.top: tasklisttitle.top
                background: Rectangle {
                    color: "#4A90E2"
                    radius: 5
                }
                Text {
                    text: qsTr("显示全部任务")
                    color: "white"
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
                onClicked: {
                    tasklistdata = tasksetService.tasksets()
                }

            }


            // 区域可选任务列表
            Rectangle {
                id: tasklistarea

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: currentemployeetaskarea.right
                anchors.leftMargin: 10
                anchors.top: maparea.bottom
                anchors.topMargin: 45
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                // 可用任务列表
                ListView {
                    id: tasklist

                    anchors.fill: parent
                    model: tasksetdata
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
                        height: 90
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
                            id: tasklistitemname
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top:parent.top
                            anchors.topMargin: 10
                            text: name
                            color: "#292826"
                            font.styleName: "Medium"
                            font.pointSize: 12
                        }

                        Text {
                            id: tasklistitemarea

                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: tasklistitemname.bottom
                            anchors.topMargin: 5
                            text: content
                            color: "#292826"
                            font.pointSize: 10
                        }
                        Text {
                            id: tasklistitemduration

                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            text:qsTr("时长")+duration + qsTr("小时")
                            color: "#292826"
                            font.pointSize: 10
                        }

                        // 在时长的后面显示周期
                        Text {
                            id: tasklistitemcycle

                            anchors.left: tasklistitemduration.right
                            anchors.leftMargin: 10
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            text: qsTr("任务周期:") + cycleToString(cycle)
                            color: "#292826"
                            font.pointSize: 10
                        }

                        // 任务地点
                        Text {
                            id: tasklistitempos
                            anchors.left: tasklistitemcycle.right
                            anchors.leftMargin: 10
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            text: qsTr("任务地点:") + area
                            color: "#292826"
                            font.pointSize: 10
                        }

                        Button {
                            id: currentemployeetaskdelegatebutton
                            width: 100
                            height: 50
                            visible: isNotInEmployeeTaskList(tid)
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                color: "#28D33F"
                                radius: 5
                            }
                            Text {
                                text: qsTr("委派任务")
                                color: "white"
                                anchors.centerIn: parent
                                font.pointSize: 14
                            }
                            onClicked: {
                                taskService.addTask(employeedata.get(employeelist.currentIndex).employid, tid)
                            }
                        }

                        // 取消任务按钮
                        Button {
                            id: currentemployeetaskdelegatecancelbutton
                            width: 100
                            height: 50
                            visible: !isNotInEmployeeTaskList(tid)
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                color: "#D33F3F"
                                radius: 5
                            }
                            Text {
                                text: qsTr("取消委派")
                                color: "white"
                                anchors.centerIn: parent
                                font.pointSize: 14
                            }
                            onClicked: {
                                taskService.removeTask(employeedata.get(employeelist.currentIndex).employid, tid)
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
