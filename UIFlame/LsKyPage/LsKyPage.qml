import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtWebEngine

Item {
    id: emlpoyeepage

    Rectangle {
        anchors.fill: parent
        radius: 5

        Text {
            id: text

            z: 0
            anchors.centerIn: parent
            text: "正在载入,请稍后..."
            font.pixelSize: 30
            color: "#292826"
        }

        Timer {
            id: timer

            interval: 200
            running: true
            repeat: true
            onTriggered: {
                if (webview.loading) {
                    if (text.text == "正在载入,请稍后.")
                        text.text = "正在载入,请稍后..";
                    else if (text.text == "正在载入,请稍后..")
                        text.text = "正在载入,请稍后...";
                    else if (text.text == "正在载入,请稍后...")
                        text.text = "正在载入,请稍后....";
                    else if (text.text == "正在载入,请稍后....")
                        text.text = "正在载入,请稍后.....";
                    else
                        text.text = "正在载入,请稍后.";
                } else {
                    text.text = "载入完成";
                }
            }
        }

        WebEngineView {
            id: webview

            z: 1
            visible: false
            anchors.fill: parent
            anchors.bottomMargin: 30
            opacity: webview.visible ? 1 : 0
            url: "http://lsky.ssimp.stvsljl.com/"
            onLoadingChanged: {
                if (!loading)
                    webview.visible = true;

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }

            }

        }

        Rectangle {
            width: parent.width
            height: 25
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            color: "#F0F0F0"
            radius: 5
            clip: true

            Text {
                //滚动字母效果, 一直滚动

                id: rolltext

                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "请注意! 您已进入图床管理系统,一般情况下图床由系统自动管理,请勿随意操作,否则可能导致图片无法正常显示!"
                font.pixelSize: 15
                color: "#FF0000"

                SequentialAnimation on x {
                    loops: Animation.Infinite

                    // 从左向右滚动
                    NumberAnimation {
                        from: -rolltext.width
                        to: parent.width + rolltext.width
                        duration: parent.width * 50
                    }

                    // 暂停
                    PauseAnimation {
                        duration: 1000
                    }

                }

            }

        }

    }

}
