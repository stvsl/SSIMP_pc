

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Shapes

Item {
    id: delegate
    width: ListView.view.width
    height: 60

    Rectangle {
        id: rectangle
        anchors.fill: parent
        visible: true
        color: isHover == true ? "#F7F7F7" : "white"
        state: isHover
        Shape {
            anchors.fill: parent
            ShapePath {
                strokeWidth: 0
                strokeColor: "#EEEEEE"
                strokeStyle: ShapePath.SolidLine
                startX: 20
                startY: 59
                PathLine {
                    x: parent.width - 20
                    y: 59
                }
            }
        }
    }

    Text {
        id: label
        color: "#343434"
        text: name
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    property bool isHover: false
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (delegate.ListView.view.currentIndex !== index) {
                delegate.ListView.view.currentIndex = index
                if (name === qsTr("全局概要")) {
                    mainstack.pop()
                    mainstack.push(globaloverview, {})
                } else if (name === qsTr("数据监控")) {
                    mainstack.pop()
                    mainstack.push(datamonitoring, {})
                } else if (name === qsTr("员工管理")) {
                    mainstack.pop()
                    mainstack.push(staffmanagement, {})
                } else if (name === qsTr("工作任务")) {
                    mainstack.pop()
                    mainstack.push(worktask, {})
                } else if (name === qsTr("内容管理")) {
                    mainstack.pop()
                    mainstack.push(contentmanagement, {})
                } else if (name === qsTr("超级管理")) {
                    mainstack.pop()
                    mainstack.push(supermanagement, {})
                } else if (name === qsTr("系统维护")) {
                    mainstack.pop()
                    mainstack.push(systemmaintenance, {})
                } else if (name === qsTr("软件设置")) {
                    mainstack.pop()
                    mainstack.push(settings, {})
                } else if (name === qsTr("关         于")) {
                    mainstack.pop()
                    mainstack.push(about, {})
                }
            }
        }
        hoverEnabled: true
        onEntered: isHover = true
        onExited: isHover = false
    }
    states: [
        State {
            name: "Highlighted"

            when: delegate.ListView.isCurrentItem
            PropertyChanges {
                target: label
                color: "#323643"
                anchors.topMargin: 30
            }

            PropertyChanges {
                target: rectangle
                visible: false
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#c0c0c0";formeditorZoom:2;height:60;width:300}
}
##^##*/

