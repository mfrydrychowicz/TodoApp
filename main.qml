import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
import "ToDo"

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Todo application")

    header: ToolBar {
        id: headerToolbar
        Layout.fillWidth: true
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

            RoundButton {
                id: addButton
                display: AbstractButton.IconOnly
                icon.source: "qrc:///icons/images/baseline_add_black_20.png"
                icon.color: "white"
                onClicked: toDoList.addItem()
            }
            RoundButton {
                id: deleteButton
                display: AbstractButton.IconOnly
                icon.source: "qrc:///icons/images/baseline_delete_black_20.png"
                icon.color: "white"
                onClicked: toDoList.removeSelectedItems()
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 2
        ColumnLayout {
            Layout.preferredWidth: parent.width / 3
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true

            Label {
                padding: 5
                color: "gray"
                text: "Pending"

                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            }
            ToDoList {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        ColumnLayout {
            Layout.preferredWidth: parent.width / 3
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true

            Label {
                padding: 5
                color: "blue"
                text: "In progress"

                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            }
            ToDoList {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        ColumnLayout {
            Layout.preferredWidth: parent.width / 3
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true

            Label {
                padding: 5
                color: "green"
                text: "Done"

                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            }
            ToDoList {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

//    Pane {
//        padding: 10
//        anchors.fill:parent
//        ColumnLayout {
//            anchors.fill:parent
//            ToDoList {
//                Layout.fillHeight: true
//            }
//        }
//    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
