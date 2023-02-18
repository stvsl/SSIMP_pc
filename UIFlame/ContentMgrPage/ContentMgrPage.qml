import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtWebEngine
import Service.Employee 1.0

Item {
    id: emlpoyeepage

    layer.smooth: true

    Timer {
        id: timer

        interval: 100
        running: true
        repeat: false
        onTriggered: {
        }
    }

    ListModel {
        id: employeedata
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
            text: qsTr("内容管理")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        // 左侧文章列表
        Rectangle {
            id: leftarea

            width: 400
            height: parent.height - 50
            layer.enabled: true
            radius: 10

            ListView {
                id: employeelist

                anchors.fill: parent
                anchors.margins: 8
                anchors.bottomMargin: 300
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

            // 功能区
            Rectangle {
                id: functionarea

                width: parent.width
                height: 150
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                color: "#F5F5F5"
                radius: 10

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    anchors.bottomMargin: 0
                    spacing: 10

                    ColumnLayout {
                        spacing: 10

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                    }

                    ColumnLayout {
                        spacing: 10

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                    }

                    ColumnLayout {
                        spacing: 10

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                        Text {
                            text: "任务委派"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 15
                        }

                    }

                }

            }

            // 宽度变化时动画
            Behavior on width {
            NumberAnimation {
                duration: 200
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
        color: "transparent"

        Text {
            id: carouselmgrtitle

            text: "轮播设置"
            height: 25
            color: "#8E99A5"
            font.styleName: "Medium"
            font.pointSize: 18

            Behavior on height {
            NumberAnimation {
                duration: 200
            }

        }

    }

    // 轮播系统设置面板
    Rectangle {
        id: carouselmgrpanel

        width: parent.width
        y: 35
        height: 200
        radius: 10
        layer.enabled: true
        color: "white"

        Behavior on height {
        NumberAnimation {
            duration: 400
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
    anchors.top: carouselmgrpanel.bottom
    anchors.topMargin: 5
    width: parent.width
    height: 35
    color: "transparent"

    Text {
        text: "内容编辑"
        width: 120
        height: 25
        color: "#8E99A5"
        font.styleName: "Medium"
        font.pointSize: 18
    }

    Rectangle {
        width: 80
        height: 25
        color: "#1791FF"
        radius: 3
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: qsTr("沉浸模式")
            color: "white"
            font.styleName: "Medium"
            font.pointSize: 10
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (leftarea.visible)
                {
                    leftarea.visible = false;
                    carouselmgrpanel.height = 0;
                    carouselmgrpanel.y = 0;
                    carouselmgrtitle.height = 0;
                    carouselmgrtitle.visible = false;
                    carouselmgrpanel.visible = false;
                    leftarea.width = 0;
                } else {
                leftarea.visible = true;
                carouselmgrpanel.height = 200;
                carouselmgrpanel.y = 35;
                carouselmgrtitle.height = 25;
                carouselmgrtitle.visible = true;
                carouselmgrpanel.visible = true;
                leftarea.width = 400;
            }
        }
    }

}

}

// 内容编辑器
Rectangle {
    id: contenteditor

    width: parent.width
    anchors.top: carouselmgrpanel.bottom
    anchors.topMargin: 40
    anchors.bottom: parent.bottom
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
    color: "white"

    WebEngineView {
        id: webview
        anchors.fill: parent
        anchors.margins: 10
        anchors.bottomMargin: parent.height/5
        url: "qrc:/htmlpage/htmlpage/contentedit.html"
    }
    // 分割线
    Rectangle {
        width: parent.width
        height: 1
        color: "#E5E5E5"
        anchors.top: webview.bottom
        anchors.topMargin: 3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 3
    }
    // 底部信息编辑面板
    Rectangle{
        id: bottompanel

        width: parent.width
        anchors.top: webview.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left:parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        clip: true
        // 标题, 封面, 简介, 页面大图, 文章状态
        ScrollView{
            anchors.fill: parent
            anchors.rightMargin: parent.width*0.4

            // 标题
            Row{
                height:35
                width: parent.width
                Text{
                    width: 95
                    text: qsTr("文章标题:")
                    color: "#AA201F1F"
                    font.styleName: "Medium"
                    font.pointSize: 14
                }
                TextField{
                    id:articletitle
                    width: parent.width - 105
                    height: 35
                    placeholderText: qsTr("请输入文章标题~")
                    font.styleName: "Normal"
                    font.pointSize: 12
                    color: "#082342"
                    horizontalAlignment: Text.AlignCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalTop
                    focus: true
                }
            }
            // 多行支持的简介
            Row{
                height:parent.height - 30
                width: parent.width
                anchors.bottom: parent.bottom

                Text{
                    width: 95
                    text: qsTr("文章简介:")
                    color: "#AA201F1F"
                    font.styleName: "Medium"
                    font.pointSize: 14
                }
                Rectangle{
                    width: parent.width - 105
                    height: parent.height
                    TextArea{
                        id:articlesummary
                        anchors.fill: parent
                        placeholderText: qsTr("请输入文章简介~")
                        font.styleName: "Normal"
                        font.pointSize: 10
                        color: "#082342"
                        focus: true
                        // 禁止大小改变和溢出
                        clip: true
                        onTextChanged: {
                            // 最大3行, 200字
                            if (text.length > 200)
                            {
                                text = text.substring(0, 200);
                            } var lines = text.split("\n");
                            if (lines.length > 3)
                            {
                                lines = lines.slice(0, 3);
                                text = lines.join("\n");
                            }
                        }
                        wrapMode: TextEdit.Wrap

                        // 右下角字数指示器 当前/最大
                        Text{
                            id:wordcount
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 10
                            anchors.rightMargin: 5
                            text: articlesummary.text.length + "/200"
                            color: "#AA201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 8
                        }

                    }
                }

            }
        }
    }
}
}
}
}

