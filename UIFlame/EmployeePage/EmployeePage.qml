import Data.Employee 1.0
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtWebEngine
import Service.Employee 1.0

Item {
    id: emlpoyeepage

    // Material主题，蓝色
    Material.theme: Material.Light
    layer.smooth: true

    Timer {
        id: timer

        interval: 100
        running: true
        repeat: false
        onTriggered: {
            employeeService.getEmployeeInfoList();
            infochartanimation.start();
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
            // console.log("employee list changed: " + typeof employeeService.employees());
            // console.log("employee list changed: " + employeeService.employees().length);
            employeeCount.text = employeeService.employees().length;
            employeedata.clear();
            if (upordown.checked)
            {
                employeedata.clear();
                for (var i = employeeService.employees().length - 1; i >= 0; i--) {
                    var employee = employeeService.employees()[i];
                    employeedata.append(employee);
                }
            } else {
            employeedata.clear();
            for (var j = 0; j < employeeService.employees().length; j++) {
                var employe = employeeService.employees()[j];
                employeedata.append(employe);
            }
        }
    }

    target: employeeService
}

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
                            id: employeeCount

                            text: employeeService.employees().length
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
                            text: "1"
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
                        source: "qrc:/icon/EmployeePage/icon/EmployeePage/人员情况.png"
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
                            text: "1"
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
                        source: "qrc:/icon/EmployeePage/icon/EmployeePage/签到签退人数.png"
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
                            text: "50%"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            width: 80
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
                            text: "33.3%"
                            verticalAlignment: Text.AlignVCenter
                            width: 80
                            height: 50
                            font.styleName: "Medium"
                            font.pointSize: 18
                            color: "#082342"
                        }

                    }

                }

                Rectangle {
                    width: 75
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 20

                    Image {
                        source: "qrc:/icon/EmployeePage/icon/EmployeePage/缺勤率完成率.png"
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

            Row {
                anchors.fill: parent
                anchors.margins: 10

                Column {
                    width: parent.width
                    height: parent.height

                    Row {
                        x: 20
                        width: parent.width
                        height: 50
                        spacing: 10

                        Text {
                            width: 68
                            height: 50
                            text: qsTr("查找员工:")
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font.styleName: "Normal"
                            font.pointSize: 12
                            color: "#082342"
                        }

                        TextField {
                            id: searchinput

                            width: 150
                            height: 40
                            placeholderText: qsTr("请输入员工工号")
                            font.styleName: "Normal"
                            font.pointSize: 12
                            color: "#082342"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                            focus: true
                        }

                        Switch {
                            id: searchtype

                            width: 35
                            height: 35
                            scale: 0.75
                            anchors.verticalCenter: parent.verticalCenter
                            layer.smooth: true
                            onCheckedChanged: {
                                if (searchtype.checked)
                                    searchinput.placeholderText = qsTr("请输入员工姓名");
                                else
                                    searchinput.placeholderText = qsTr("请输入员工工号");
                                }
                            }

                            //    模式Text
                            Text {
                                id: searchtypetext

                                width: 68
                                height: 50
                                text: searchtype.checked ? qsTr("按姓名查找") : qsTr("按工号查找")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                        }

                        // 按钮组 下拉列表（全部，缺勤，迟到，早退，出勤），添加员工，导出
                        Row {
                            x: 20
                            width: parent.width
                            height: 50
                            spacing: 10

                            Text {
                                width: 68
                                height: 50
                                text: qsTr("规则筛选:")
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Normal"
                                font.pointSize: 12
                                color: "#082342"
                            }

                            // 下拉列表
                            ComboBox {
                                id: searchtypebox

                                width: 100
                                height: 40
                                font.styleName: "Normal"
                                font.pointSize: 12
                                model: ["全部", "缺勤", "迟到", "早退", "出勤"]
                                currentIndex: 0
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                width: 100
                                height: 30
                                color: "#1791FF"
                                radius: 5
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: qsTr("添加员工")
                                    color: "white"
                                    font.styleName: "Medium"
                                    font.pointSize: 12
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                    }
                                }

                            }

                            Rectangle {
                                width: 100
                                height: 30
                                color: "#1791FF"
                                radius: 5
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: qsTr("导出列表")
                                    color: "white"
                                    font.styleName: "Medium"
                                    font.pointSize: 12
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                    }
                                }

                            }

                        }

                    }

                }

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
                    scale: 0.5
                    rotation: 270
                    layer.smooth: true
                    onCheckedChanged: {
                        var index = employeelist.currentIndex;
                        if (upordown.checked)
                        {
                            employeedata.clear();
                            for (var i = employeeService.employees().length - 1; i >= 0; i--) {
                                var employee = employeeService.employees()[i];
                                employeedata.append(employee);
                            }
                            employeelist.currentIndex = employeeService.employees().length - 1 - index;
                        } else {
                        employeedata.clear();
                        for (var j = 0; j < employeeService.employees().length; j++) {
                            var employe = employeeService.employees()[j];
                            employeedata.append(employe);
                        }
                        employeelist.currentIndex = employeeService.employees().length - 1 - index;
                    }
                }
            }

            Text {
                width: 35
                height: parent.height
                color: "#8E99A5"
                text: upordown.checked ? qsTr("升序") : qsTr("降序")
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
        width: parent.width / 5 + 25
        height: parent.height - topinfobar.height - 110
        layer.enabled: true

        ListView {
            id: employeelist

            anchors.fill: parent
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
                //populate Transition is end

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

            /* displaced属性
            * 此属性用于指定通用的、由于model变化导致Item位移时的动画效果，还有removeDisplaced、moveDisplaced
            * 如果同时指定了displaced 和xxxDisplaced, 那么xxxDisplaced生效
            */
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
                            infochartview.setEid(employid);
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
            anchors.fill: parent
            anchors.margins: 30
            spacing: 25

            Flow {
                id: mainflow

                width: (parent.width / 5) * 3
                spacing: 21

                Item {
                    width: parent.width
                    height: 30

                    Row {
                        Text {
                            text: qsTr("员工编号(EID): ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).employid
                            height: 25
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width / 5
                    height: 30

                    Row {
                        Text {
                            text: qsTr("姓名: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).name
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width / 6
                    height: 30

                    Row {
                        Text {
                            text: qsTr("性别: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).idNumber[16] % 2 === 0 ? qsTr("女") : qsTr("男")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width / 6
                    height: 30

                    Row {
                        Text {
                            text: qsTr("年龄: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            // 通过身份证号码计算年龄
                            text: new Date().getFullYear() - parseInt(employeedata.get(employeelist.currentIndex).idNumber.substring(6, 10))
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width / 6
                    height: 30

                    Row {
                        Text {
                            text: qsTr("出生日期: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).idNumber.substring(6, 10) + "年" + employeedata.get(employeelist.currentIndex).idNumber.substring(10, 12) + "月" + employeedata.get(employeelist.currentIndex).idNumber.substring(12, 14) + "日"
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width
                    height: 30

                    Row {
                        Text {
                            text: qsTr("身份证号: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).idNumber
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width
                    height: 30

                    Row {
                        Text {
                            text: qsTr("家庭地址: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).address
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width * 11 / 30 + 25
                    height: 30

                    Row {
                        Text {
                            text: qsTr("雇佣日期: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).hireDate.substring(0, 4) + "年" + employeedata.get(employeelist.currentIndex).hireDate.substring(5, 7) + "月" + employeedata.get(employeelist.currentIndex).hireDate.substring(8, 10) + "日"
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                Item {
                    width: parent.width / 2
                    height: 30

                    Row {
                        Text {
                            text: qsTr("联系电话: ")
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                        Text {
                            text: employeedata.get(employeelist.currentIndex).tel
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 16
                        }

                    }

                }

                // 修改信息, 删除员工, 重置密码, 更新人像照片按钮
                Item {
                    width: parent.width
                    height: 40

                    Row {
                        spacing: 35
                        anchors.left: parent.left

                        Rectangle {
                            width: 120
                            height: 40
                            color: "#1791FF"
                            radius: 5

                            Text {
                                text: qsTr("修改信息")
                                color: "white"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                }
                            }

                        }

                        Rectangle {
                            width: 120
                            height: 40
                            color: "#1791FF"
                            radius: 5

                            Text {
                                text: qsTr("重置密码")
                                color: "white"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                }
                            }

                        }

                        Rectangle {
                            width: 160
                            height: 40
                            color: "#1791FF"
                            radius: 5

                            Text {
                                text: qsTr("更新人像照片")
                                color: "white"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                }
                            }

                        }

                        Rectangle {
                            width: 135
                            height: 40
                            color: "#FF516B"
                            radius: 5

                            Text {
                                text: qsTr("删除此员工")
                                color: "white"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                }
                            }

                        }

                    }

                }

            }

            Item {
                id: photoview

                width: parent.width / 3
                height: parent.height / 3

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 20

                    Text {
                        text: qsTr("员工照片")
                        color: "#AA201F1F"
                        font.styleName: "Medium"
                        font.pointSize: 18
                    }

                    Rectangle {
                        width: parent.width / 2
                        height: parent.width * 3 / 4
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 10

                        Image {
                            id: infoimage

                            anchors.fill: parent
                            anchors.margins: 10
                            anchors.centerIn: parent
                            source: employeedata.get(employeelist.currentIndex).photoUrl
                            // fillMode: 拉伸填充
                            fillMode: Image.PreserveAspectFit
                        }

                    }

                }

            }

            Item {
                // 底部分割线
                width: parent.width
                height: 1

                Rectangle {
                    width: parent.width / 1.1
                    height: 1

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

            Item {
                width: parent.width
                height: parent.height - photoview.height - 80

                Rectangle {
                    id: infochart

                    anchors.fill: parent

                    WebEngineView {
                        id: infochartview
                        anchors.fill: parent
                        url: "qrc:/htmlpage/htmlpage/employeeinfo.html"

                        function setEid(eid)
                        {
                            infochartview.runJavaScript("setEid(" + eid + ")")
                        }
                    }

                    PropertyAnimation {
                        id: infochartanimation

                        target: infochart
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 500
                        running: false
                        loops: 1
                    }

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
