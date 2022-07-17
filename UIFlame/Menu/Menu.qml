import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

ListView {
    id: view
    width: 290
    height: 600
    highlightMoveDuration: 0

    children: [
        Rectangle {
            color: "#FFFFFF"
            anchors.fill: parent
            z: -1
        }
    ]

    model: MenuModel {}

    highlight: Rectangle {
        width: view.width
        height: 20
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                GradientStop {
                    position: 0.010
                    color: "#ffffff"
                }
                GradientStop {
                    position: 0.011
                    color: "#03b0f0"
                }
                GradientStop {
                    position: 0.041
                    color: "#04befe"
                }
                GradientStop {
                    position: 0.042
                    color: "#dfe9f3"
                }
                GradientStop {
                    position: 1.0
                    color: "#ffffff"
                }
            }
        }

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

    delegate: MenuDelegate {}
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}
}
##^##*/

