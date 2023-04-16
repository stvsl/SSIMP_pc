import "../MessageBox"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Service.Account
import Utils.Verify
import QtQuick.Controls.Material

Window {
    id: loginpage

    Material.theme: Material.Blue

    property string _Putvercode
    property real windowRotation: 0
        property bool dragging: false

            AccountService {
                id: accountService
            }

            function powerverify()
            {
                if (verify.text !== loginpage._Putvercode)
                {
                    errloader.sourceComponent = verifyerr
                    verificationItem.slt_reflushVerification()
                    userid.clear()
                    passwd.clear()
                    verify.clear()
                } else {
                accountService.login(userid.text, passwd.text)
            }
        }

        width: 770
        height: 460
        visible: true
        color: "#ffffff"
        flags: Qt.Window | Qt.FramelessWindowHint

        // 连接信号槽
        Connections {
            function onLoginSuccess()
            {
                console.log("登录成功")
                daemon.switchtoMain()
            }

            function onLoginFailed()
            {
                console.log("登录失败")
                errloader.sourceComponent = infoerr
                verificationItem.slt_reflushVerification()
                userid.clear()
                passwd.clear()
                verify.clear()
            }

            target: accountService
        }

        // 窗口rotation
        RotationAnimation {
            id: rotation

            target: loginpage
            from: 0
            to: 360
            duration: 1000
            running: false
            loops: Animation.Infinite
        }

        Image {
            z: 1
            anchors.fill: parent
            source: "qrc:/login/Login/background.jpg"
            layer.smooth: true
        }

        Rectangle {
            id: rectangle

            z: 10
            opacity: 0.8
            anchors.fill: parent
            width: parent.width - 100
            height: parent.height - 100
            color: Qt.rgba(1, 1, 1, 0.2)

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(width, height)

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

                Rectangle {
                    id: devbtn
                    x: 54
                    y: 122
                    width: 200
                    height: 100
                    color: "#ffffff"
                    z:100
                    visible: true
                    Text {
                        x: 0
                        y: 0
                        width: 192
                        height: 92
                        text: "debug"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 20
                        font.weight: Font.Bold
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            accountService.login("1000000001", "stvsl2060")
                        }
                    }
                }

                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: Qt.rgba(0, 91 / 255, 224 / 255, 0.5)
                    }

                    GradientStop {
                        position: 1
                        color: Qt.rgba(0, 128 / 255, 251 / 255, 0.5)
                    }
                }
            }

            Rectangle {
                width: parent.width / 2.3
                height: parent.height
                anchors.right: parent.right
                color: Qt.rgba(1, 1, 1, 0.1)

                Rectangle {
                    id: verificationPainter

                    width: parent.width / 1.15
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

                        TextField {
                            id: userid

                            x: parent.width / 9
                            y: parent.height / 6.65
                            width: parent.width / 1.3
                            height: 40
                            placeholderText: qsTr("请输入用户ID")
                            placeholderTextColor: "#CCCCFF"
                            font.pixelSize: 14
                        }

                        TextField {
                            id: passwd

                            anchors.left: userid.left
                            y: parent.height / 2.85
                            anchors.right: userid.right
                            height: 40
                            placeholderText: qsTr("请输入密码")
                            placeholderTextColor: "#CCCCFF"
                            echoMode: TextInput.Password
                            font.pixelSize: 14
                        }

                        TextField {
                            id: verify

                            anchors.left: userid.left
                            y: parent.height / 1.76
                            width: parent.width / 2.5
                            height: 40
                            placeholderText: qsTr("请输入验证码")
                            placeholderTextColor: "#CCCCFF"
                            font.pixelSize: 14
                        }

                        Rectangle {
                            anchors.left: verify.right
                            anchors.top: verify.top
                            anchors.right: userid.right
                            anchors.bottom: verify.bottom
                            anchors.bottomMargin: 6
                            anchors.leftMargin: 12
                            anchors.rightMargin: 5

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
                                function onClicked()
                                {
                                    verificationItem.slt_reflushVerification()
                                }

                                target: verchange
                            }

                            //获取字符
                            Connections {
                                function onVerificationChanged()
                                {
                                    _Putvercode = verificationItem.verification
                                }

                                target: verificationItem
                            }
                        }

                        Rectangle {
                            id: loginbtn

                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 5.5
                            y: parent.height / 1.3
                            width: 85
                            height: 35
                            color: Qt.rgba(0.72, 1, 1, 0.8)
                            focus: true
                            Keys.onPressed: event => {
                            if (event.key === Qt.Key_Enter)
                                loginpage.powerverify()
                        }
                        radius: 5

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
                    }

                    Rectangle {
                        id: canclebtn

                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 5.5
                        y: parent.height / 1.3
                        width: 85
                        height: 35
                        color: Qt.rgba(0.72, 1, 1, 0.8)
                        border.color: "#FFFFFF"
                        border.width: 0
                        radius: 5

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

    Loader {
        id: errloader

        anchors.centerIn: parent
    }

    Connections {
        function onBtnClicked(x)
        {
            errloader.sourceComponent = null
            loginbtn.color = Qt.rgba(0.72, 1, 1, 0.8)
        }

        target: errloader.item
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
        property point clickPos: "0, 0"

            //为窗口添加鼠标事件
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton //只处理鼠标左键
            onPressed: mouse => {
            //接收鼠标按下事件
            clickPos = Qt.point(mouse.x, mouse.y)
            loginpage.dragging = true
        }
        onReleased: loginpage.dragging = false
        onPositionChanged: mouse => {
        //鼠标按下后改变位置
        //鼠标偏移量
        var delta = Qt.point(mouse.x - clickPos.x,
        mouse.y - clickPos.y)
        //如果mainwindow继承自QWidget, 用setPos
        loginpage.setX(loginpage.x + delta.x)
        loginpage.setY(loginpage.y + delta.y)
    }
}

// 当窗口处于拖动状态时，播放旋转动画
NumberAnimation {
    target: loginpage
    property: "windowRotation"
    to: loginpage.dragging ? 20 : 0
    duration: 100
    easing.type: Easing.OutBounce
}
}
