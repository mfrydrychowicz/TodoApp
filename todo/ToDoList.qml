import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material.impl 2.12
import Qt5Compat.GraphicalEffects

import ToDoModel 1.0
import todo.ToDoItem 1.0

ListView {

    readonly property int _margin: 5
    property alias list : listViewModel.list
    id: listView
    implicitWidth:  parent.implicitWidth
    implicitHeight: parent.implicitWidth
    clip: true
    spacing: 5
    leftMargin: _margin
    rightMargin: _margin
    topMargin: _margin
    bottomMargin: _margin

    ScrollBar.vertical: ScrollBar {
        width: 4
    }

    model: ToDoModel {
        id: listViewModel
//        list: toDoList
    }


    delegate: Item {
        implicitWidth: parent ? parent.width : Math.max(labelRow.implicitWidth, todoDetails.implicitWidth)
        implicitHeight: todoItem.implicitHeight

        Pane {
            id: todoItem
            width: parent.width
            contentHeight: calculateHeight()
            function calculateHeight() {
                var height = labelRow.implicitHeight //+ 20
                //                console.log(model.label, model.done) // why sometimes undefined undefined?
                if (model.details && model.details.length > 0) {
                    height = height + todoDetails.implicitHeight + separator.implicitHeight //+ 30
                }
                return height
            }

            background: Rectangle {
                id: paneBackground
                border.width: 1
                radius: 5
                border.color: model.isSelected ? "red" : "white"
            }
            RowLayout {
                id: labelRow
                anchors.left: parent.left
                anchors.right: parent.right
                height: todoLabel.height

                TextInput {
                    id: todoLabel
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: model.label
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    focus: true
                }

                Item
                {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                    Button {
                        id: editButton

//                        anchors.right: parent.right
                        icon.source: "qrc:///icons/images/baseline_edit_black_20.png"
                        icon.color: "lightgray"
                        icon.width: 18
                        icon.height: 18
                        padding: 0
    //                    width: icon.width
    //                    height: icon.height
                        visible: true /*hovered*/
                        background: Rectangle {
                            color: "transparent"
                            anchors.fill: parent
                        }

                    }

                    MouseArea {
                        id: editButtonMouseArea
                        anchors.fill: editButton
                        propagateComposedEvents: true
                        onClicked: {
                            todoLabel.readOnly = !todoLabel.readOnly
                            todoLabel.focus = true
                            todoLabel.activeFocusOnPress = true
                            console.log(todoLabel.readOnly)
                        }
                    }
                }

            }

            MouseArea {
                id: maEditButton
                anchors.fill: labelRow
                hoverEnabled: true         //this line will enable mouseArea.containsMouse
                propagateComposedEvents: true
                onEntered: {
                    editButton.visible = true
                }

                onExited: {
                    editButton.visible = false
                }
//                onClicked: {
//                    console.log("AAAAAAAAAAAAA")
//                }
            }
            ToolSeparator {
                id: separator
                orientation: Qt.Horizontal
                anchors.top: labelRow.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                visible: model.details.length > 0
            }
            TextEdit {
                leftPadding: 10
                rightPadding: 10
                id: todoDetails
                font.pointSize: 10
                text: model.details
                anchors.top: separator.bottom
                width: parent.width - 20
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                visible: model.details.length > 0

            }

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onDoubleClicked: {
                    model.isSelected = !model.isSelected
                }
            }




        }

        DropShadow {
            id: todoItemShadow
            anchors.fill: todoItem
            horizontalOffset: 0
            verticalOffset: 0
            radius: 6
            color: "lightgray"
            source: todoItem
            transparentBorder: true
        }
    }
}
