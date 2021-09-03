import QtQuick 2.0
import QtQuick.Controls 2.12

RoundButton {
    id: root
    property alias iconSrc: root.icon.source
    display: AbstractButton.IconOnly
    icon.color: "white"
}
