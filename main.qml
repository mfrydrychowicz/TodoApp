import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Todo application")

    header: ToolBar {

        id: headerToolbar
        Layout.fillWidth: true

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
                visible: true
                color: "white"
                anchors.left: headerToolbar.left
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
            }

            RoundButton {
                id: deleteButton
                display: AbstractButton.IconOnly
                icon.source: "qrc:///icons/images/baseline_delete_black_20.png"
            }
        }


    }

    Pane {


    }

}
