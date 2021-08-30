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
    minimumWidth: 650
    minimumHeight: 480
    visible: true
    title: qsTr("Todo application")

    Popup {
        id: addItemPopup
        modal: true
        focus: true
        anchors.centerIn: Overlay.overlay
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        function clearUserInput() {
            tfTodoTitle.text = ""
            tfTodoDetails.text = ""
        }

        function restorePopup() {
            tfTodoTitle.focus = true
            clearUserInput()
        }
        onClosed: restorePopup()



        background: Rectangle {
            readonly property int popupMargin: 10
            radius: 5
            width: 400//contents.implicitWidth + popupMargin * 2
            height: contents.implicitHeight + popupMargin * 2
            anchors.centerIn : parent


            ColumnLayout {
                id: contents
                anchors.margins: parent.popupMargin
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                TextField {
                    id: tfTodoTitle
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    placeholderText: qsTr("Enter title")
                    focus: true
                    background: Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 3
                        color: parent.focus ? "limegreen" : "lightgreen"
                        radius: 8
                        clip: true
                        antialiasing: true
                    }
                }

                TextField {
                    id: tfTodoDetails
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    placeholderText: qsTr("Enter details")
                    background: Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 3
                        color: parent.focus ? "limegreen" : "lightgreen"
                        radius: 8
                        clip: true
                        antialiasing: true
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    Button {
                        text: "Add"
                        onClicked: {
                            console.log("Add button clicked")
                            toDoList.addItem(tfTodoTitle.text, tfTodoDetails.text)
                            addItemPopup.close()
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                        background: Rectangle {
                            color: parent.down ? "lightgreen" : "limegreen"
                            border.color: "transparent"
                            border.width: 1
                            radius: 5
                        }

                    }
                    Button {
                        text: "Cancel"
                        onClicked: {
                            addItemPopup.close()
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: parent.down ? "lightgreen" : "limegreen"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                        background: Rectangle {
                            opacity: enabled ? 1 : 0.3
                            border.color: parent.down ? "lightgreen" : "limegreen"
                            border.width: 1
                            radius: 5
                        }
                    }
                }
            }
        }
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
                onClicked: addItemPopup.open()
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
