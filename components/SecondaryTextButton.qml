import QtQuick 2.0
import QtQuick.Controls 2.12

Button {
    contentItem: Text {
        text: parent.text
        font: parent.font
        color: parent.down ? "limegreen" : "green"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        opacity: enabled ? 1 : 0.3
        border.color: parent.down ? "limegreen" : "green"
        border.width: 1
        radius: 5
    }
}
