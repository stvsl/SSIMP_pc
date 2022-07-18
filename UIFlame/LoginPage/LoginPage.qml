import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import Utils.Verify

Window {
    width: 770
    height: 460
    visible: true
    flags: Qt.FramelessWindowHint

    Image {
        anchors.fill: parent
        source: "qrc:/login/Login/background.jpg"
        layer.smooth: true
    }
    Rectangle {
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
                width: parent.width / 1.18
                height: parent.height / 1.5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 15
                color: Qt.rgba(1, 1, 1, 0.1)

                Text {
                    x: parent.width / 15
                    y: parent.height / 20
                    text: qsTr("Text")
                    font.pixelSize: 20
                    font.italic: true
                    font.bold: true
                    color: "white"
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
}
