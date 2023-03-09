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

    ListModel {
        id: neartasklistdata
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
        webview.settings.setAttribute(WebEngineSettings.LocalContentCanAccessRemoteUrls, true)
        webview.settings.setAttribute(WebEngineSettings.JavascriptCanAccessClipboard, true)
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
            anchors.top: parent.top
            anchors.topMargin: 50
            width: 350
            height: parent.height - 50
            z: 1
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
            }
        }


        Rectangle {
            id: rightarea
            radius: 10
            z: 0
            color: "transparent"
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.bottom: leftarea.bottom
            anchors.left: leftarea.right
            anchors.right: parent.right
            anchors.rightMargin: 10
            // 任务详情
            Text {
                text: qsTr("任务详情")
                height: 30
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 20
                color: "#8E99A5"
                font.styleName: "Medium"
                font.pointSize: 18
            }

            Rectangle {
                id: mainarea

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: -10
                layer.enabled: true
                radius: 10

                Rectangle {
                    id: correnttaskarea

                    width: 420
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    height: parent.height
                    radius: 10
                    color: "#88FFFFFF"

                    Text {
                        id: areataskid
                        text: qsTr("任务编号:  ") + tasklistdata.get(tasklist.currentIndex).tid
                        height: 40
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 16
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
                        font.pointSize: 16
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
                        font.pointSize: 12
                    }

                    Text {
                        id: areataskcontent
                        text: qsTr("任务内容: ")
                        height: 160
                        anchors.top: areataskname.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 16
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    TextArea {
                        id: areataskcontentinput
                        text: tasklistdata.get(tasklist.currentIndex).content
                        anchors.top: areataskname.bottom
                        anchors.topMargin: 10
                        anchors.left: areataskcontent.right
                        anchors.leftMargin: 10
                        width: 250
                        height: 155
                        font.pointSize: 12
                        onTextChanged: {
                            // 最大3行, 200字
                            if (text.length > 100)
                            {
                                text = text.substring(0, 100)
                            }
                            var lines = text.split("\n")
                            if (lines.length > 3)
                            {
                                lines = lines.slice(0, 3)
                                text = lines.join("\n")
                            }
                        }
                        wrapMode: TextEdit.Wrap
                        Text {
                            id: wordcount
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 10
                            anchors.rightMargin: 5
                            text: areataskcontentinput.text.length + "/100"
                            color: "#A0201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 6
                        }
                    }

                    Text {
                        id: areataskarea
                        text: qsTr("任务区域: ")
                        height: 40
                        anchors.top: areataskcontent.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.pointSize: 16
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
                        font.pointSize: 12
                    }

                    Text {
                        id: areataskstatus
                        text: qsTr("任务状态: ")
                        height: 40
                        anchors.top: areataskarea.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 16
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    ComboBox {
                        id: areataskstatusbox
                        model: ["任务下线", "日常执行"]
                        anchors.top: areataskarea.bottom
                        anchors.left: areataskstatus.right
                        anchors.leftMargin: 10
                        width: 140
                        height: 50
                        font.pointSize: 14
                        currentIndex: tasklistdata.get(tasklist.currentIndex).state
                    }

                    Text {
                        id: areatasklocation
                        text: qsTr("位置信息:  ") + tasklistdata.get(tasklist.currentIndex).poslo + "\n\t    " +tasklistdata.get(tasklist.currentIndex).posli
                        width: parent.width
                        height: 40
                        anchors.top: areataskstatus.bottom
                        anchors.topMargin: 10
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 16
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    // 分割线
                    Rectangle {
                        width: parent.width * 0.9
                        height: 1
                        anchors.top: areatasklocation.bottom
                        anchors.topMargin: 20
                        color: "#EEEEEE"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 操作中心
                    Text{
                        id: areataskoperate
                        text: qsTr("操作中心")
                        height: 40
                        anchors.top: areatasklocation.bottom
                        anchors.topMargin: 40
                        color: "#8E99A5"
                        font.styleName: "Medium"
                        font.pointSize: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                    }

                    Flow{
                        anchors.top: areataskoperate.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        spacing: 10

                        // 编辑按钮
                        Button {
                            id: areataskedit
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: areataskedittext
                                anchors.centerIn: parent
                                text: qsTr("编辑任务")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (areataskedittext.text == "编辑任务")
                                {
                                    areataskedittext.text = "保存任务"
                                    areatasknameinput.enabled = true
                                    areataskcontentinput.enabled = true
                                    areataskareainput.enabled = true
                                    areataskstatusbox.enabled = true
                                }
                                else
                                {
                                    areataskedittext.text = "编辑任务"
                                    areatasknameinput.enabled = false
                                    areataskcontentinput.enabled = false
                                    areataskareainput.enabled = false
                                    areataskstatusbox.enabled = false
                                }
                            }
                        }

                        // 添加任务
                        Button {
                            id: areataskadd
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: areataskaddtext
                                anchors.centerIn: parent
                                text: qsTr("添加任务")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                tasklistdata.append({
                                "name": "新任务",
                                "content": "新任务内容",
                                "area": "新任务区域",
                                "state": 0,
                                "poslo": "0.000000",
                                "posli": "0.000000"
                            })}
                        }

                        // 删除按钮
                        Button {
                            id: areataskdelete
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#FF516B"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: areataskdeletetext
                                anchors.centerIn: parent
                                text: qsTr("删除任务")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {

                            }
                        }

                        // 任务查找输入框
                        TextField {
                            id: areataskfindinput
                            width: 250
                            height: 50
                            font.pointSize: 14
                            placeholderText: qsTr("请输入任务名称")
                        }

                        // 任务查找按钮
                        Button {
                            id: areataskfind
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#F4A236"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: areataskfindtext
                                anchors.centerIn: parent
                                text: qsTr("查找此任务")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {

                            }
                        }

                        Text{
                            text: qsTr("地图导航")
                            width: parent.width
                            height: 40
                            color: "#8E99A5"
                            font.styleName: "Medium"
                            font.pointSize: 20
                        }

                        // 卫星地图模式/平面地图模式切换按钮
                        Button {
                            id: mapmode
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapmodetext
                                anchors.centerIn: parent
                                text: qsTr("卫星地图")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (mapmodetext.text == "卫星地图")
                                {
                                    mapmodetext.text = "平面地图"
                                }
                                else
                                {
                                    mapmodetext.text = "卫星地图"
                                }
                            }
                        }

                        // 坐标定位开关
                        Button {
                            id: maplocate
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: maplocatetext
                                anchors.centerIn: parent
                                text: qsTr("获取定位")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (maplocatetext.text == "获取定位")
                                {
                                    maplocatetext.text = "取消定位"
                                }
                                else
                                {
                                    maplocatetext.text = "获取定位"
                                }
                            }
                        }

                        // 允许地图缩放设置
                        Button {
                            id: mapzoom
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapzoomtext
                                anchors.centerIn: parent
                                text: qsTr("允许缩放")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (mapzoomtext.text == "允许缩放")
                                {
                                    mapzoomtext.text = "禁止缩放"
                                }
                                else
                                {
                                    mapzoomtext.text = "允许缩放"
                                }
                            }
                        }

                        // 允许拖拽
                        Button {
                            id: mapdrag
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapdragtext
                                anchors.centerIn: parent
                                text: qsTr("允许拖拽")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (mapdragtext.text == "允许拖拽")
                                {
                                    mapdragtext.text = "禁止拖拽"
                                }
                                else
                                {
                                    mapdragtext.text = "允许拖拽"
                                }
                            }
                        }

                        // 显示当前任务坐标/显示全部任务坐标
                        Button {
                            id: mapshowtask
                            width: 250
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapshowtasktext
                                anchors.centerIn: parent
                                text: qsTr("显示当前任务坐标")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (mapshowtasktext.text == "显示当前任务坐标")
                                {
                                    mapshowtasktext.text = "显示全部任务坐标"
                                }
                                else
                                {
                                    mapshowtasktext.text = "显示当前任务坐标"
                                }
                            }
                        }

                        // 回到中心位置
                        Button {
                            id: mapcenter
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapcentertext
                                anchors.centerIn: parent
                                text: qsTr("回到原点")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {

                            }
                        }

                        // 跟随移动
                        Button {
                            id: mapfollow
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapfollowtext
                                anchors.centerIn: parent
                                text: qsTr("跟随移动")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {
                                if (mapfollowtext.text == "跟随移动")
                                {
                                    mapfollowtext.text = "取消跟随"
                                }
                                else
                                {
                                    mapfollowtext.text = "跟随移动"
                                }
                            }
                        }

                        // 清除缓存
                        Button {
                            id: mapclearcache
                            width: 120
                            height: 50
                            font.pointSize: 16

                            background: Rectangle {
                                color: "#1791FF"
                                border.color: "#EEEEEE"
                                border.width: 1
                                radius: 5
                            }

                            Text {
                                id: mapclearcachetext
                                anchors.centerIn: parent
                                text: qsTr("清除缓存")
                                color: "#FFFFFF"
                                font.pointSize: 16
                            }
                            onClicked: {

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

                // 地图导航
                Rectangle {
                    id: maparea
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: correnttaskarea.right
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height / 3
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
                                if (loadingtext.text == "正在载入地图, 请稍后...")
                                {
                                    loadingtext.text = "正在载入地图, 请稍后."
                                }
                                else if (loadingtext.text == "正在载入地图, 请稍后.")
                                {
                                    loadingtext.text = "正在载入地图, 请稍后.."
                                }
                                else if (loadingtext.text == "正在载入地图, 请稍后..")
                                {
                                    loadingtext.text = "正在载入地图, 请稍后..."
                                }
                            }
                            else{
                                loadingtext.text = "载入完成"
                                // 停止计时器
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
                    anchors.right: parent.right
                    anchors.left: maparea.left
                    anchors.top: maparea.bottom
                    anchors.topMargin: 10
                    anchors.bottom: parent.bottom

                    Text {
                        id: neartasklisttitle
                        text: qsTr("附近任务")
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        font.pointSize: 18
                        color: "#8E99A5"
                    }

                    ListView{
                        id: neartask
                        anchors.top: neartasklisttitle.bottom
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        model: neartasklistdata

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



