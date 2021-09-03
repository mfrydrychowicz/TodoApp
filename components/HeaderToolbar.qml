import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12


ToolBar {
    height: 50
    background: Rectangle {
        color: Universal.color(Universal.Emerald)
        opacity: 0.7
    }

    RowLayout {
        spacing: 10
        anchors {
            leftMargin: 10
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        Text {
            id: applicationName
            text: "Todo application"
            color: "white"
            font.bold: true
        }
    }
    RowLayout {
        spacing: 10
        anchors {
            rightMargin: 10
            leftMargin: 10
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        implicitWidth: addButton.implicitWidth + deleteButton.implicitWidth + 10

        RoundIconButton {
            id: addButton
            iconSrc: "qrc:///icons/images/baseline_add_black_20.png"
            onClicked: addItemPopup.open()
        }


        RoundIconButton {
            id: deleteButton
            iconSrc: "qrc:///icons/images/baseline_delete_black_20.png"
            onClicked:  {
                toDoListPending.removeSelectedItems()
                toDoListInProgress.removeSelectedItems()
                toDoListDone.removeSelectedItems()
            }
        }
    }
}
