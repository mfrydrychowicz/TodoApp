import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
import Qt5Compat.GraphicalEffects
import "ToDo"

import "./components"

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
        implicitWidth: contents.width
        implicitHeight: contents.height

        function clearUserInput() {
            tfTodoTitle.text = ""
            tfTodoDetails.text = ""
        }

        function restorePopup() {
            tfTodoTitle.focus = true
            clearUserInput()
        }
        onClosed: restorePopup()

        Rectangle {
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

                FormTextField {
                    id: tfTodoTitle
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    placeholderText: qsTr("Enter title")
                    focus: true
                }

                FormTextField {
                    id: tfTodoDetails
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    placeholderText: qsTr("Enter details")
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    PrimaryTextButton {
                        text: "Add"
                        onClicked: {
                            toDoListPending.addItem(tfTodoTitle.text, tfTodoDetails.text)
                            addItemPopup.close()
                        }
                    }
                    SecondaryTextButton {
                        text: "Cancel"
                        onClicked: {
                            addItemPopup.close()
                        }
                    }
                }
            }
        }
    }

    header: HeaderToolbar{}

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
                            list: toDoListPending
                        }
                    }


                }

                Shadow {
                    anchors.fill: pendingColumnBorder
                    source: pendingColumnBorder
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
                            list: toDoListInProgress
                        }
                    }
                }

                Shadow {
                    anchors.fill: inProgressColumnBorder
                    source: inProgressColumnBorder
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
                            list: toDoListDone
                        }
                    }
                }

                Shadow {
                    anchors.fill: doneColumnBorder
                    source: doneColumnBorder
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
