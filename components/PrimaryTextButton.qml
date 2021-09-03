import QtQuick 2.0
import QtQuick.Controls 2.12

Button {
    contentItem: Text {
        text: parent.text
        font: parent.font
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        color: parent.down ? "limegreen" : "green"
        border.color: "transparent"
        border.width: 1
        radius: 5
    }
}
