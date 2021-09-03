import QtQuick 2.0
import QtQuick.Controls 2.12

TextField {
    background: Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: parent.focus ? "green" : "limegreen"
        radius: 8
        clip: true
        antialiasing: true
    }
}
