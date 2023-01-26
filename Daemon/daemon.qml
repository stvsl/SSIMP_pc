import "../UIFlame/LoadPage"
import "../UIFlame/LoginPage"
import "../UIFlame/MainPage"
import "../UIFlame/MessageBox"
import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: daemon

    // 对话框类型
    property int dialogtype: 0
    // 对话框按钮类型
    property int dialogbtntype: 0
    // 对话框标题
    property string dialogtitle: ""
    // 对话框内容
    property string dialogcontent: ""

    signal dialogClickedBtn(int x)

    function switchtoMain() {
        daemonloader.sourceComponent = mainpage;
    }

    function switchtoLogin() {
        daemonloader.sourceComponent = loginpage;
    }

    function showDialog(type, btntype, title, content) {
        daemon.dialogtype = type;
        daemon.dialogbtntype = btntype;
        daemon.dialogtitle = title;
        daemon.dialogcontent = content;
        dialogloader.sourceComponent = dialog;
    }

    // 紧急退出
    function emergencyExit() {
        Qt.quit();
    }

    visible: false
    Component.onCompleted: daemonloader.sourceComponent = loadpage

    Loader {
        id: daemonloader

        anchors.centerIn: parent
    }

    Loader {
        id: dialogloader

        anchors.centerIn: parent
    }

    Component {
        id: dialog

        MessageBox {
            id: msgbox

            // 按钮类型 确定 | 取消
            property bool conform: daemon.dialogbtntype === 0 ? true : false || daemon.dialogbtntype === 2 ? true : false
            // 按钮类型 是 | 否
            property bool yesorno: daemon.dialogbtntype === 1 ? true : false
            // 按钮类型 确定
            property bool justconform: daemon.dialogbtntype === 2 ? true : false

            // 消息弹窗标题
            texts: daemon.dialogtitle
            // 消息弹窗内容
            helptext: daemon.dialogcontent
            // 消息弹窗类型：tips：提示窗口 | msg：消息窗口 | warn：警告窗口 | error：错误窗口
            type: daemon.dialogtype === 0 ? "tips" : daemon.dialogtype === 1 ? "msg" : daemon.dialogtype === 2 ? "warn" : "error"
            onBtnClicked: function(x) {
                daemon.dialogClickedBtn(x);
                dialogloader.sourceComponent = null;
            }
        }

    }

    Component {
        id: loadpage

        LoadPage {
        }

    }

    Component {
        id: mainpage

        MainPage {
        }

    }

    Component {
        id: loginpage

        LoginPage {
        }

    }

}
