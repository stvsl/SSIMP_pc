import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: emlpoyeepage
    layer.smooth: true
    width: parent.width
    height: parent.height

    Flow {
        anchors.fill: parent
        anchors.margins: 10
        layer.smooth: true
        antialiasing: true
        spacing: 10
        Rectangle{
            width: parent.width
            height: 120
        }
        Rectangle{
            width: parent.width /2.5
            height: 120
        }

        Rectangle{
            width: parent.width/2.5
            height: 120
        }



    }





}
