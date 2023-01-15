import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "../UIFlame/LoadPage"
import "../UIFlame/MainPage"
import "../UIFlame/LoginPage"
import "../UIFlame/MessageBox"

Window {
    visible: false
    width: 640
    height: 380
    id: daemon

    function switchtoMain()
    {
        daemonloader.sourceComponent = mainpage
    }

    function switchtoLogin()
    {
        daemonloader.sourceComponent = loginpage
    }

    function showDialog(type, btntype, title, content)
    {
        console.log("showDialog" + type + btntype + title + content)
    }

    Loader {
        id: daemonloader
        anchors.centerIn: parent // 弹出的界面都居中显示
    }

    Component.onCompleted: daemonloader.sourceComponent = loadpage

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
