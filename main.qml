import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4

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
            color: "green"
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
            }
            RoundButton {
                id: deleteButton
                display: AbstractButton.IconOnly
                icon.source: "qrc:///icons/images/baseline_delete_black_20.png"
                icon.color: "white"
            }
        }
    }
    Pane {
        padding: 10
        anchors.fill:parent
        ColumnLayout {
            anchors.fill:parent
            ToDoList {
//                anchors.fill:parent
                //        anchors.centerIn: parent
//                anchors.fill:parent
                Layout.fillHeight: true

            }
        }
    }



}
