import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
//import QtQuick.Controls.Material 2.12
import Qt5Compat.GraphicalEffects
import "ToDo"

ApplicationWindow {
    id: mainWindow
    width: 650
    height: 480
    visible: true
    title: qsTr("Todo application")

    Popup {
        id: addItemPopup
        modal: true
        focus: true
        anchors.centerIn: Overlay.overlay
        background: Rectangle {
            readonly property int popupMargin: 10
            radius: 5
            implicitWidth: contents.implicitWidth + popupMargin * 2
            implicitHeight: contents.implicitHeight + popupMargin * 2

            ColumnLayout {
                id: contents
                anchors.centerIn : parent

                TextField {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    placeholderText: qsTr("Enter name")
                }

                RowLayout {
                    Button {
                        text: "Add"
                        onClicked: {
                            console.log("Add button clicked")
                        }
                    }
                    Button {
                        text: "Cancel"
                        onClicked: {
                            console.log("Cancel button clicked")
                        }
                    }
                }
            }

        }


        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }

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
                onClicked: addItemPopup.open()//toDoList.addItem()
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

    Item {
        anchors.fill:parent
        anchors.margins: 15
        RowLayout {
            anchors.fill: parent
            spacing: 4

            Item {
                Component.onCompleted: {
                    console.log(this.width)
                }

                Layout.preferredWidth: parent.width / 3
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                Rectangle {
                    id: pendingColumnBorder
                    anchors.fill:parent
                    //                    Layout.preferredWidth: parent.width / 3
                    //                    Layout.fillHeight: true
                    //                    Layout.alignment: Qt.AlignCenter
                    radius: 8
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        anchors.fill: parent

                        Label {
                            topPadding: 8
                            bottomPadding: 4
                            color: "lightsteelblue"
                            font.pixelSize: 16
                            text: "Pending"
                            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                        }


                        Rectangle {
                            Layout.fillWidth: true
                            height: 4
                            color: "lightsteelblue"
                        }

                        ToDoList {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }


                }
                DropShadow {
                    anchors.fill: pendingColumnBorder
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 6
                    color: "lightgray"
                    source: pendingColumnBorder
                    transparentBorder: true
                }
            }
            Item {
                Layout.preferredWidth: parent.width / 3
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                Rectangle {
                    id: inProgressColumnBorder
                    //                    Layout.preferredWidth: parent.width / 3
                    //                    Layout.fillHeight: true
                    //                    Layout.alignment: Qt.AlignCenter
                    anchors.fill:parent
                    radius: 8
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        anchors.fill: parent


                        Label {
                            topPadding: 8
                            bottomPadding: 4
                            color: "dodgerblue"
                            font.pixelSize: 16
                            text: "In progress"
                            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                        }


                        Rectangle {
                            Layout.fillWidth: true
                            height: 4
                            color: "dodgerblue"
                        }

                        ToDoList {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
                DropShadow {
                    anchors.fill: inProgressColumnBorder
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 6
                    color: "lightgray"
                    source: inProgressColumnBorder
                    transparentBorder: true
                }
            }
            Item {
                Layout.preferredWidth: parent.width / 3
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                Rectangle {
                    anchors.fill:parent
                    id: doneColumnBorder
                    //                    Layout.preferredWidth: parent.width / 3
                    //                    Layout.fillHeight: true

                    //                    Layout.alignment: Qt.AlignCenter
                    radius: 8
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        anchors.fill: parent


                        Label {
                            topPadding: 8
                            bottomPadding: 4
                            color: "lightseagreen"
                            font.pixelSize: 16
                            text: "Done"
                            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                        }


                        Rectangle {
                            Layout.fillWidth: true
                            height: 4
                            color: "lightseagreen"
                        }

                        ToDoList {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
                DropShadow {
                    anchors.fill: doneColumnBorder
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 6
                    color: "lightgray"
                    source: doneColumnBorder
                    transparentBorder: true
                }
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
