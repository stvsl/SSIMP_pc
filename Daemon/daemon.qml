﻿import QtQuick
import QtQuick.Window
import "../UIFlame/LoadPage"
import "../UIFlame/MainPage"
import "../UIFlame/LoginPage"

Window {
    visible: false
    width: 640
    height: 380
    id: daemon

    function switchtoMain() {
        daemonloader.sourceComponent = mainpage
    }

    function switchtoDaemon() {}

    Loader {
        id: daemonloader
        anchors.centerIn: parent // 弹出的界面都居中显示
    }

    Component.onCompleted: daemonloader.sourceComponent = loginpage

    Component {
        id: loadpage
        LoadPage {}
    }

    Component {
        id: mainpage
        MainPage {}
    }
    Component {
        id: loginpage
        LoginPage {}
    }
}
