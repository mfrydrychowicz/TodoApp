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
    implicitWidth:  parent.width
    implicitHeight: parent.height
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
                border.color: model.isSelected ? "limegreen" : "white"
            }

            RowLayout {
                id: labelRow
                anchors.left: parent.left
                anchors.right: parent.right
                height: todoLabel.height

                Item {
                    id: name
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    TextEdit {
                        id: todoLabel
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        text: model.label
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        selectedTextColor: "white"
                        selectionColor: "limegreen"
                        selectByMouse: true
                    }
//                    MouseArea {
//                        anchors.fill: todoLabel
//                        propagateComposedEvents: true

//                        onClicked: {
//                            console.log ("AAA")
//                            todoLabel.enabled = true
//                            itemMouseArea.enabled = false
//                            this.enabled = false
//                        }
//                    }
                }


                Item
                {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                    Button {
                        property bool isSelected: false
                        property bool isVisible: false
                        id: editButton

                        icon.source: "qrc:///icons/images/baseline_edit_black_20.png"
                        icon.color: isSelected ? "limegreen" : "lightgray"
                        icon.width: 18
                        icon.height: 18
                        padding: 0
                        width: icon.width
                        height: icon.height
                        visible: isVisible
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
                            editButton.isSelected = !editButton.isSelected
                            editButton.isVisible = editButton.isSelected

                            if (editButton.isSelected) {
                                maToDoItemLabel.enabled = false
                                itemMouseArea.enabled = false
                                todoLabel.readOnly = false
                                todoDetails.readOnly = false
                            } else {
                                maToDoItemLabel.enabled = true
                                itemMouseArea.enabled = true
                                todoLabel.readOnly = true
                                todoDetails.readOnly = true
                            }
                        }
                    }
                }

            }

            MouseArea {
                property alias isEnabled: maToDoItemLabel.enabled
                id: maToDoItemLabel
                enabled: true
                anchors.fill: labelRow
                hoverEnabled: true         //this line will enable mouseArea.containsMouse
//                propagateComposedEvents: true
                onEntered: {
                    editButton.isVisible = true
                }

                onExited: {
                    editButton.isVisible = editButton.isVisible && editButton.isSelected
                }
                onClicked: {
                    console.log("Label clicked. Enabled: ", enabled)

                    mouse.accepted = false
                }
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
                selectByMouse: true
                selectedTextColor: "white"
                selectionColor: "limegreen"
            }

            MouseArea {
                id: itemMouseArea
                anchors.fill: parent
                propagateComposedEvents: true
                onDoubleClicked: {
                    model.isSelected = !model.isSelected
                }
                onClicked: {
//                    console.log("TodoItem clicked, mouse event onClicked not accepted")
                    mouse.accepted = false
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
