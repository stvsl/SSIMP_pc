import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects
import Utils.Verify

Window {
    width: 770
    height: 460
    visible: true
    flags: Qt.FramelessWindowHint

    //    Material.theme: Material.Blue
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
                y: 46
                width: 457
                height: 83
                text: qsTr("北镇闾山景区巡查监测平台")
                font.pixelSize: 33
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.italic: true
                font.family: "Arial"
            }
        }
        Rectangle {
            width: parent.width / 2.5
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
                    font.pixelSize: 20
                    font.italic: false
                    font.bold: true
                    color: "white"
                }

                Item {
                    anchors.fill: parent
                    anchors.topMargin: parent.width / 6

                    Text {
                        x: parent.width / 10
                        y: parent.height / 12
                        text: qsTr("用户ID")
                        font.pixelSize: 12
                    }

                    Text {
                        x: parent.width / 10
                        y: parent.height / 3.3
                        text: qsTr("密码")
                        font.pixelSize: 12
                    }

                    Text {
                        x: parent.width / 10
                        y: parent.height / 1.9
                        id: text3
                        text: qsTr("验证码")
                        font.pixelSize: 12
                    }

                    TextField {
                        id: userid
                        x: parent.width / 4
                        y: parent.height / 6.5
                        width: parent.width / 1.5
                        height: 40
                        placeholderText: qsTr("请输入用户ID")
                        font.pixelSize: 14
                    }

                    TextField {
                        id: passwd
                        x: parent.width / 4
                        y: parent.height / 2.85
                        width: parent.width / 1.5
                        height: 40
                        placeholderText: qsTr("请输入密码")
                        font.pixelSize: 14
                    }

                    TextField {
                        id: verify
                        x: parent.width / 4
                        y: parent.height / 1.8
                        width: parent.width / 3
                        height: 40
                        placeholderText: qsTr("请输入验证码")
                        font.pixelSize: 14
                    }
                }

                //            VerificationCode {
                //                id: verificationItem
                //                anchors.left: parent.left
                //                anchors.top: parent.top
                //                anchors.right: parent.right
                //                anchors.bottom: parent.bottom
                //            }
            }
            //******************************************************************//
            //        //刷新
            //        Connections {
            //            target: verchange
            //            onClicked: {
            //                verificationItem.slt_reflushVerification()
            //            }
            //        }
            //        //******************************************************************//
            //        //获取字符
            //        Connections {
            //            target: verificationItem
            //            onVerificationChanged: {
            //                _Putvercode = verificationItem.verification
            //            }
            //        }
        }
    }

    Button {
        z: 10
        id: button
        x: 727
        y: 0
        width: 43
        height: 35
        text: qsTr("X")
        color: Qt.rgba(1, 1, 1, 0)
    }
}
