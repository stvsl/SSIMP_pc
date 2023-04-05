import QtQuick 2.15

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Data.Feedback
import Data.Employee
import Service.Feedback
import Service.Employee
import Service.Taskset

Item {
    id: taskpage
    // Material主题，蓝色
    Material.theme: Material.Light
    layer.smooth: true

    Component.onCompleted: {
        feedbackservice.getFeedbackListALL()
        feedbacklist.currentIndex = 0
    }

    FeedbackService {
        id:feedbackservice
    }

    ListModel {
        id: feedbackdata
    }

    TaskSetService {
        id: tasksetservice
    }

    Timer {
        id: timer

        interval: 100
        running: true
        repeat: false
        onTriggered: {
            employeeService.getEmployeeInfoList();
        }
    }

    EmployeeService {
        id: employeeService
    }

    ListModel {
        id: employeedata
    }

    Connections {
        function onEmployeeInfoListChanged()
        {
            employeedata.clear();
            for (var i = employeeService.employees().length - 1; i >= 0; i--) {
                var employee = employeeService.employees()[i];
                employeedata.append(employee);
            }
        }

        target: employeeService
    }


    Connections {
        target: feedbackservice

        function onFeedbackListGet(list)
        {
            var nowindex = feedbacklist.currentIndex
            if (feedbackdata.count > 0)
                feedbackdata.clear()
            for (var i = 0; i < list.length; i++) {
                feedbackdata.append(list[i])
            }
            // 判断当前是不是最后一个
            if (nowindex > feedbackdata.count)
            {
                nowindex = feedbackdata.count-1
            }
            feedbacklist.currentIndex = nowindex
        }
    }

    function statusToImage(status)
    {
        if (status === 0)
        {
            return "qrc:/picture/feedbackstatus/picture/feedbackstatus/已提交.png"
        }
        if (status === 1)
        {
            return "qrc:/picture/feedbackstatus/picture/feedbackstatus/已接受.png"
        }

        if (status === 2)
        {
            return "qrc:/picture/feedbackstatus/picture/feedbackstatus/未完成.png"
        }

        if (status === 3)
        {
            return "qrc:/picture/feedbackstatus/picture/feedbackstatus/已完成.png"
        }

        if (status === 4)
        {
            return "qrc:/picture/feedbackstatus/picture/feedbackstatus/已废弃.png"
        }
        return ""
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 0
        layer.smooth: true
        antialiasing: true

        Text {
            width: 200
            height: 40
            color: "#8E99A5"
            text: qsTr("异常反馈")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        Rectangle {
            id: leftarea

            width: 350
            height: parent.height - 50
            layer.enabled: true
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 50
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
                    height: 85
                    width: feedbacklist.width

                    Rectangle {
                        anchors.fill: parent
                        // 判断是否选中
                        color: feedbacklist.currentIndex === index ? "#F5F5F5" : "transparent"
                        radius: 10

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                feedbacklist.currentIndex = index
                                feedbackconverttotaskpanel.enabled=false
                                feedbackconverttotasktitleinput.text=""
                                feedbackconverttotaskcontentinput.text=""
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

                            // 反馈编号
                            Text {
                                id: fqid
                                text: qsTr("编号：") + qid
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.top: parent.top
                                anchors.topMargin: 8
                            }

                            // 反馈标题
                            Text {
                                text: qsTr("问题: ") +question
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 12
                                anchors.left: parent.left
                                anchors.leftMargin: 16
                                anchors.top: fqid.bottom
                                anchors.topMargin: 1
                            }

                            // 反馈时间
                            Text {
                                text: create_date
                                color: "#AA8E99A5"
                                font.styleName: "Medium"
                                font.pointSize: 10
                                anchors.left: parent.left
                                anchors.leftMargin: 16
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 4
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

                TextField {
                    id: searchinput
                    width: parent.width * 0.6
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    height: 40
                    placeholderText: qsTr("输入反馈者信息以搜索")
                    font.pointSize: 12
                }

                Button {
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    width: parent.width * 0.3-5
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
                    id: searchinput2
                    anchors.top: searchinput.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    width: parent.width * 0.6
                    height: 40
                    placeholderText: qsTr("输入问题内容以搜索")
                    font.pointSize: 12
                }

                Button {
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.top: searchinput.bottom
                    width: parent.width * 0.3-5
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
                    id: sorttext
                    text: qsTr("排序方式")
                    color: "#535060"
                    height: 40
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: searchinput2.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    font.weight: Font.Medium
                }
                // 升降序
                Switch {
                    id: feedbacksortswitch
                    anchors.top: searchinput2.bottom
                    anchors.left:sorttext.right
                    width: 130
                    height: 40
                    checked: false
                    text: checked ? qsTr("升序排序") : qsTr("降序排序")
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
            width: parent.width - leftarea.width-10
            height: leftarea.height
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.left: leftarea.right
            anchors.leftMargin: 10
            radius: 10
            color: "transparent"

            Text {
                id: feedbacktitle
                text: qsTr("反馈详情")
                color: "#535060"
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 16
                font.weight: Font.Medium
            }

            Rectangle {
                id: feedbackdetail
                width: parent.width
                height: 300
                anchors.top: feedbacktitle.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
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
                    id: feedbackdetailid
                    text: qsTr("反馈编号：")
                    color: "#292826"
                    width: 150
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 18
                    font.weight: Font.Medium
                }

                Text {
                    text: feedbackdata.get(feedbacklist.currentIndex).qid
                    color: "#292826"
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailid.right
                    anchors.leftMargin: 10
                    font.pointSize: 18
                    font.weight: Font.Medium
                }

                Text {
                    id: feedbackdetailtitle
                    text: qsTr("反馈标题：")
                    color: "#292826"
                    width: 150
                    anchors.top: feedbackdetailid.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    text: feedbackdata.get(feedbacklist.currentIndex).question
                    color: "#292826"
                    anchors.top: feedbackdetailid.bottom
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailtitle.right
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }


                Text {
                    id: feedbackdetailcontent
                    text: qsTr("详细内容：")
                    color: "#292826"
                    width: 150
                    anchors.top: feedbackdetailtitle.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    elide: Text.ElideRight
                    maximumLineCount: 2
                }

                Text {
                    id: feedbackdetailcontenttext
                    text: feedbackdata.get(feedbacklist.currentIndex).description
                    color: "#292826"
                    anchors.top: feedbackdetailtitle.bottom
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailcontent.right
                    anchors.leftMargin: 10
                    font.pointSize: feedbackdetailcontenttext.text.length < 25 ? 16 : feedbackdetailcontenttext.text.length < 60 ? 14 : feedbackdetailcontenttext.text.length < 100 ? 12 : 10
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 3
                    width: parent.width * 0.4
                }

                Text {
                    id: feedbackdetailcreator
                    text: qsTr("创建人/发起人：")
                    color: "#292826"
                    width: 150
                    anchors.top: feedbackdetailcontenttext.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    text: feedbackdata.get(feedbacklist.currentIndex).sponsor
                    color: "#292826"
                    anchors.top: feedbackdetailcontenttext.bottom
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailcreator.right
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    id: feedbackdetailcontact
                    text: qsTr("联系方式：")
                    width: 150
                    color: "#292826"
                    anchors.top: feedbackdetailcreator.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    text: feedbackdata.get(feedbacklist.currentIndex).teleinfo
                    color: "#292826"
                    anchors.top: feedbackdetailcreator.bottom
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailcontact.right
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    id: feedbackdetailassign
                    text: qsTr("委派负责人：")
                    color: "#292826"
                    width: 150
                    anchors.top: feedbackdetailcontact.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    text: feedbackdata.get(feedbacklist.currentIndex).principal
                    color: "#292826"
                    anchors.top: feedbackdetailcontact.bottom
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailassign.right
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    id: feedbackdetailtime
                    text: qsTr("反馈时间：")
                    color: "#292826"
                    width: 150
                    anchors.top: feedbackdetailassign.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Text {
                    text: feedbackdata.get(feedbacklist.currentIndex).create_date
                    color: "#292826"
                    anchors.top: feedbackdetailassign.bottom
                    anchors.topMargin: 8
                    anchors.left: feedbackdetailtime.right
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }
                Image {
                    id: status
                    source: statusToImage(feedbackdata.get(feedbacklist.currentIndex).status)
                    width: 200
                    height: 200
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                }
            }

            Text {
                id: operationcenter
                text: qsTr("操作中心")
                color: "#535060"
                anchors.top: feedbackdetail.bottom
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 16
                font.weight: Font.Medium
            }

            Flow {
                id: operation
                anchors.top: operationcenter.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
                width: parent.width - 20
                spacing: 10

                Button {
                    id: justaccept
                    width: 200
                    height: 55

                    background: Rectangle {
                        color: "#1791FF"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("仅接受反馈")
                        color: "#FFFFFF"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setToAccept(feedbackdata.get(feedbacklist.currentIndex).qid)
                    }
                }

                Button {
                    id: acceptandconvert
                    width: 200
                    height: 55

                    background: Rectangle {
                        color: "#1791FF"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("接受并转换为任务")
                        color: "#FFFFFF"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setToAccept(feedbackdata.get(feedbacklist.currentIndex).qid)
                        feedbackconverttotaskpanel.enabled=true
                        feedbackconverttotasktitleinput.text=feedbackdata.get(feedbacklist.currentIndex).question
                        feedbackconverttotaskcontentinput.text=feedbackdata.get(feedbacklist.currentIndex).description
                    }
                }

                Button {
                    id: setascompleted
                    width: 200
                    height: 55
                    background: Rectangle {
                        color: "#1791FF"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("直接设置为已完成")
                        color: "#FFFFFF"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setToSolve(feedbackdata.get(feedbacklist.currentIndex).qid)
                    }
                }

                Button {
                    id: rejectanddiscard
                    width: 200
                    height: 55

                    background: Rectangle {
                        color: "#FF516B"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("不接受并废弃")
                        color: "white"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setToReject(feedbackdata.get(feedbacklist.currentIndex).qid)
                    }
                }

                Button {
                    id: deletefeedback
                    width: 200
                    height: 55

                    background: Rectangle {
                        color: "#FF516B"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("直接删除")
                        color: "white"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.Delete(feedbackdata.get(feedbacklist.currentIndex).qid)
                    }
                }
            }

            Text {
                id: feedbackconverttotasktext
                text: qsTr("任务转化")
                width: parent.width * 0.5
                color: "#535060"
                anchors.top: operation.bottom
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 16
                font.weight: Font.Medium
            }

            Rectangle {
                id: feedbackconverttotaskpanel
                width: parent.width * 0.5-10
                anchors.top: feedbackconverttotasktext.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                enabled: false

                Text {
                    id: feedbackconverttotasktitle
                    text: qsTr("任务名称：")
                    color: "#292826"
                    width: 120
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                TextField {
                    id: feedbackconverttotasktitleinput
                    width: 400
                    height: 45
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.left: feedbackconverttotasktitle.right
                    anchors.leftMargin: 10
                    font.pointSize: 14
                    placeholderText: qsTr("请输入任务名称")
                }

                Text {
                    id: feedbackconverttotaskcontent
                    text: qsTr("任务内容：")
                    color: "#292826"
                    width: 120
                    anchors.top: feedbackconverttotasktitle.bottom
                    anchors.topMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                TextArea {
                    id: feedbackconverttotaskcontentinput
                    width: 400
                    height: 150
                    anchors.top: feedbackconverttotasktitle.bottom
                    anchors.topMargin: 15
                    anchors.left: feedbackconverttotaskcontent.right
                    anchors.leftMargin: 10
                    font.pointSize: 14
                    placeholderText: qsTr("请输入任务内容")
                    wrapMode: TextEdit.Wrap
                    textFormat: TextEdit.PlainText
                }

                // 任务地点
                Text {
                    id: feedbackconverttotasklocation
                    text: qsTr("任务地点：")
                    color: "#292826"
                    width: 120
                    anchors.top: feedbackconverttotaskcontentinput.bottom
                    anchors.topMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                TextField {
                    id: feedbackconverttotasklocationinput
                    width: 400
                    height: 45
                    anchors.top: feedbackconverttotaskcontentinput.bottom
                    anchors.topMargin: 10
                    anchors.left: feedbackconverttotasklocation.right
                    anchors.leftMargin: 10
                    font.pointSize: 14
                    placeholderText: qsTr("请输入任务地点")
                }

                // 任务时长
                Text {
                    id: feedbackconverttotaskduration
                    text: qsTr("任务时长：")
                    color: "#292826"
                    width: 120
                    anchors.top: feedbackconverttotasklocation.bottom
                    anchors.topMargin: 17
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                // 下拉框
                ComboBox {
                    id: feedbackconverttotaskdurationinput
                    width: 400
                    height: 45
                    anchors.top: feedbackconverttotasklocation.bottom
                    anchors.topMargin: 10
                    anchors.left: feedbackconverttotaskduration.right
                    anchors.leftMargin: 10
                    font.pointSize: 14
                    model: ["1小时", "2小时", "3小时", "4小时", "5小时", "6小时", "7小时", "8小时", "9小时", "10小时", "11小时", "12小时", "13小时", "14小时", "15小时", "16小时", "17小时", "18小时", "19小时", "20小时", "21小时", "22小时", "23小时", "24小时"]
                }

                // 提交按钮
                Button {
                    id: feedbackconverttotasksubmit
                    width: 125
                    height: 55
                    anchors.bottom: parent.bottom
                    anchors.left: feedbackconverttotaskdurationinput.left

                    background: Rectangle {
                        color: "#1791FF"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("提交")
                        color: "#FFFFFF"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setToDoing(feedbackdata.get(feedbacklist.currentIndex).qid)
                        tasksetservice.convertFeedbackToTaskSet(feedbackconverttotasktitleinput.text, feedbackconverttotaskcontentinput.text, feedbackconverttotasklocationinput.text, feedbackconverttotaskdurationinput.currentIndex)
                        feedbackconverttotaskpanel.enabled=false
                        feedbackconverttotasktitleinput.text=""
                        feedbackconverttotaskcontentinput.text=""
                        feedbackconverttotasklocationinput.text=""
                    }
                }

                // 重置按钮
                Button {
                    id: feedbackconverttotaskreset
                    width: 125
                    height: 55
                    anchors.bottom: parent.bottom
                    anchors.left: feedbackconverttotasksubmit.right
                    anchors.leftMargin: 10
                    background: Rectangle {
                        color: "#FF516B"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("重置")
                        color: "#FFFFFF"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackconverttotasktitleinput.text=feedbackdata.get(feedbacklist.currentIndex).question
                        feedbackconverttotaskcontentinput.text=feedbackdata.get(feedbacklist.currentIndex).description
                        feedbackconverttotasklocationinput.text=""
                    }
                }

                // 取消按钮
                Button {
                    id: feedbackconverttotaskcancel
                    width: 125
                    height: 55
                    anchors.bottom: parent.bottom
                    anchors.left: feedbackconverttotaskreset.right
                    anchors.leftMargin: 10
                    background: Rectangle {
                        color: "#EEEEEE"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("取消")
                        color: "#292826"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setToOrange(feedbackdata.get(feedbacklist.currentIndex).qid)
                        feedbackconverttotasktitleinput.text=""
                        feedbackconverttotaskcontentinput.text=""
                        feedbackconverttotasklocationinput.text=""
                        feedbackconverttotaskpanel.enabled=false
                    }
                }

            }

            // 委派给
            Text {
                id: feedbackconverttotaskdelegatetotext
                text: qsTr("委派给")
                color: "#292826"
                width: parent.width * 0.5
                anchors.top: operation.bottom
                anchors.topMargin: 15
                anchors.left: feedbackconverttotasktext.right
                font.pointSize: 16
                font.weight: Font.Medium
            }

            // 委派给区域
            Rectangle {
                id: feedbackconverttotaskdelegatetoarea
                width: parent.width * 0.5
                height: 100
                anchors.top: feedbackconverttotaskdelegatetotext.bottom
                anchors.topMargin: 10
                anchors.left: feedbackconverttotasktext.right
                anchors.bottom: parent.bottom
                radius: 5
                ListView {
                    id: employeelist

                    anchors.fill: parent
                    anchors.bottomMargin: 30
                    anchors.margins: 8
                    spacing: 3
                    model: employeedata
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
                        // add transition is end

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
                                    employeelist.currentIndex = index;
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
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    id: listemployid

                                    text: "eid " + employid
                                    color: "#8E99A5"
                                    font.styleName: "Medium"
                                    font.pointSize: 10
                                    anchors.right: parent.right
                                    anchors.rightMargin: 15
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                    }
                }
                // 委派给此人
                Button {
                    id: feedbackconverttotaskdelegatetobtn
                    width: 125
                    height: 55
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    background: Rectangle {
                        color: "#1791FF"
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: 5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("委派给此人")
                        color: "#FFFFFF"
                        font.pointSize: 16
                    }
                    onClicked: {
                        feedbackservice.setDelegate(feedbackdata.get(feedbacklist.currentIndex).qid, employeedata.get(employeelist.currentIndex).name+"("+employeedata.get(employeelist.currentIndex).employid + ")");

                    }
                }
            }
        }
    }
}
