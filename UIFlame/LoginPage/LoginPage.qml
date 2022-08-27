import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects
import Utils.Verify
import "../MessageBox"
import QtQuick.Timeline 1.0

Window {
    id: loginpage
    width: 770
    height: 460
    visible: true
    color: "#ffffff"
    flags: Qt.Window | Qt.FramelessWindowHint
    property string _Putvercode
    Material.theme: Material.Blue
    Image {
        z: 1
        anchors.fill: parent
        source: "qrc:/login/Login/background.jpg"
        layer.smooth: true
    }
    Rectangle {
        z: 10
        opacity: 0.8
        id: rectangle
        anchors.fill: parent
        width: parent.width - 100
        height: parent.height - 100
        color: Qt.rgba(1, 1, 1, 0.2)
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(width, height)
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(0, 91 / 255, 224 / 255, 0.5)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0, 128 / 255, 251 / 255, 0.5)
                }
            }

            Text {
                x: 0
                y: 50
                width: 430
                height: 83
                text: qsTr("北镇闾山景区巡查监测平台")
                font.pixelSize: 32
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.italic: true
                font.family: "Courier"
            }
        }
        Rectangle {
            width: parent.width / 2.3
            height: parent.height
            anchors.right: parent.right
            color: Qt.rgba(1, 1, 1, 0.1)
            Rectangle {
                id: verificationPainter
                width: parent.width / 1.1
                height: parent.height / 1.5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 15
                color: Qt.rgba(1, 1, 1, 0.1)

                Text {
                    x: parent.width / 15
                    y: parent.height / 20
                    text: qsTr("登录")
                    font.pixelSize: 22
                    font.bold: true
                    color: Qt.rgba(1, 1, 1, 0.9)
                }

                Item {
                    anchors.fill: parent
                    anchors.topMargin: parent.width / 8

                    Text {
                        x: parent.width / 10
                        y: parent.height / 12
                        color: "#ffffff"
                        text: qsTr("用户ID")
                        font.pixelSize: 16
                    }

                    Text {
                        x: parent.width / 10
                        y: parent.height / 3.3
                        color: "#ffffff"
                        text: qsTr("密    码")
                        font.letterSpacing: 0
                        font.pixelSize: 16
                        font.wordSpacing: 2
                    }

                    Text {
                        x: parent.width / 10
                        y: parent.height / 1.9
                        color: "#ffffff"
                        id: text3
                        text: qsTr("验证码")
                        font.pixelSize: 16
                    }

                    TextField {
                        id: userid
                        x: parent.width / 3.6
                        y: parent.height / 6.65
                        width: parent.width / 1.5
                        height: 40
                        placeholderText: qsTr("请输入用户ID")
                        placeholderTextColor: "#CCCCFF"
                        font.pixelSize: 14
                    }

                    TextField {
                        id: passwd
                        x: parent.width / 3.6
                        y: parent.height / 2.85
                        width: parent.width / 1.5
                        height: 40
                        placeholderText: qsTr("请输入密码")
                        placeholderTextColor: "#CCCCFF"
                        echoMode: TextInput.Password
                        font.pixelSize: 14
                    }

                    TextField {
                        id: verify
                        x: parent.width / 3.6
                        y: parent.height / 1.76
                        width: parent.width / 3.5
                        height: 40
                        placeholderText: qsTr("请输入验证码")
                        placeholderTextColor: "#CCCCFF"
                        font.pixelSize: 14
                    }

                    Rectangle {
                        anchors.left: verify.right
                        anchors.top: verify.top
                        anchors.right: passwd.right
                        anchors.bottom: verify.bottom
                        anchors.bottomMargin: 8
                        anchors.leftMargin: 6
                        VerificationCode {
                            id: verificationItem
                            anchors.fill: parent
                            MouseArea {
                                id: verchange
                                anchors.fill: parent
                            }
                        }

                        //刷新
                        Connections {
                            target: verchange
                            function onClicked() {
                                verificationItem.slt_reflushVerification()
                            }
                        }
                        //获取字符
                        Connections {
                            target: verificationItem
                            function onVerificationChanged() {
                                _Putvercode = verificationItem.verification
                            }
                        }
                    }
                    Rectangle {
                        id: loginbtn
                        x: parent.width / 4.5
                        y: parent.height / 1.30
                        width: 85
                        height: 35
                        color: Qt.rgba(0.72, 1, 1, 0.8)
                        Text {
                            text: qsTr("登录")
                            color: Qt.rgba(0, 0, 0, 0.8)
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: loginbtn.horizontalCenter
                            anchors.verticalCenter: loginbtn.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                loginbtn.color = Qt.rgba(0.72, 1, 1, 0.4)
                                loginpage.powerverify()
                            }
                            onReleased: {
                                loginbtn.color = Qt.rgba(0.72, 1, 1, 0.8)
                            }
                        }
                        focus: true
                        Keys.onPressed: event => {
                                            if (event.key === Qt.Key_Enter) {
                                                loginpage.powerverify()
                                            }
                                        }
                        radius: 5
                    }
                    Rectangle {
                        id: canclebtn
                        x: parent.width / 1.8
                        y: parent.height / 1.30
                        width: 85
                        height: 35
                        color: Qt.rgba(0.72, 1, 1, 0.8)
                        border.color: "#FFFFFF"
                        border.width: 0
                        Text {
                            text: qsTr("清除")
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: canclebtn.horizontalCenter
                            anchors.verticalCenter: canclebtn.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            color: Qt.rgba(0, 0, 0, 0.8)
                        }
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                canclebtn.color = Qt.rgba(0.72, 1, 1, 0.4)
                                verificationItem.slt_reflushVerification()
                                userid.clear()
                                passwd.clear()
                                verify.clear()
                            }
                            onReleased: {
                                canclebtn.color = Qt.rgba(0.72, 1, 1, 0.8)
                            }
                        }
                        radius: 5
                    }
                }
            }
        }

        Rectangle {
            id: exitbtn
            width: 30
            height: 25
            anchors.top: parent.top
            anchors.right: parent.right
            color: Qt.rgba(1, 1, 1, 0)
            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("X")
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    daemon.close()
                    loginpage.close()
                    Qt.quit()
                }
            }
        }
    }

    function powerverify() {
        if (verify.text !== loginpage._Putvercode) {
            errloader.sourceComponent = verifyerr
            verificationItem.slt_reflushVerification()
            userid.clear()
            passwd.clear()
            verify.clear()
            //// TODO
            //// 完成登录逻辑
        } else {
            daemon.switchtoMain()
        }
    }

    Loader {
        id: errloader
        anchors.centerIn: parent
    }

    Connections {
        target: errloader.item
        function onBtnClicked(x) {
            errloader.sourceComponent = null
            loginbtn.color = Qt.rgba(0.72, 1, 1, 0.8)
        }
    }

    Component {
        id: verifyerr
        MessageBox {
            type: "tips"
            texts: "验证码错误"
            helptext: "请重新尝试输入验证码"
            conform: true
            yesorno: false
            justconform: true
        }
    }

    Component {
        id: infoerr
        MessageBox {
            type: "tips"
            texts: "用户ID或密码错误"
            helptext: "请重试"
            conform: true
            yesorno: false
            justconform: true
        }
    }

    MouseArea {
        //为窗口添加鼠标事件
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton //只处理鼠标左键
        property point clickPos: "0,0"
        onPressed: mouse => {
                       //接收鼠标按下事件
                       clickPos = Qt.point(mouse.x, mouse.y)
                   }
        onPositionChanged: mouse => {
                               //鼠标按下后改变位置
                               //鼠标偏移量
                               var delta = Qt.point(mouse.x - clickPos.x,
                                                    mouse.y - clickPos.y)

                               //如果mainwindow继承自QWidget,用setPos
                               loginpage.setX(loginpage.x + delta.x)
                               loginpage.setY(loginpage.y + delta.y)
                           }
    }
}
