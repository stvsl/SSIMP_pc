import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Timeline
import "../UIFlame/MessageBox"

Item {
    id:vctrler
    visible: false
    title:"北镇闾山巡检平台"
    // 枚举
    

    Loader {
        id: vctloader
        anchors.centerIn: parent
    }

    Component {
        id: dialog
        MessageBox {
            type: "tips"
            texts: "用户ID或密码错误"
            helptext: "请重试"
            conform: true
            yesorno: false
            justconform: true
        }
    }
}
