import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material.impl 2.12
import Qt5Compat.GraphicalEffects

import ToDoModel 1.0
import todo.ToDoItem 1.0

import "../components"

Rectangle {
    id: root
    property alias list : listViewModel.list

    DropArea {
        id: dropArea
        anchors { fill: root; margins: 10 }
        onDropped: (drop) => {
                       if (drop.formats) {
                           if (drop.proposedAction === Qt.MoveAction) {
                               list.addItem(drop.getDataAsString("label"), drop.getDataAsString("details"))
                               drop.acceptProposedAction()
                           }
                       }
                   }
    }
    Component {
        id: todoItemDelegate

        Item {
            //            id: todoItem
            implicitHeight: childrenRect.height
            implicitWidth: parent.width

            Pane {
                property string display: model.label
                id: todoItem
                width: parent.width
                contentHeight: calculateHeight()
                function calculateHeight() {
                    var height = todoLabel.implicitHeight //+ 20
                    console.log(model.label, model.done) // why sometimes undefined undefined?
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
                    height: todoLabel.implicitHeight

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        TextEdit {
                            id: todoLabel
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            anchors.fill: parent
                            text: model.label
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            selectedTextColor: "white"
                            selectionColor: "limegreen"
                            selectByMouse: true
                            color: "green"
                            onEditingFinished: {
                                model.label = todoLabel.text
                            }
                        }
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
                                    todoItemMouseArea.enabled = false
                                    todoLabel.readOnly = false
                                    todoDetails.readOnly = false
                                    if (model.details.length === 0) {
                                        model.details = " "
                                    }
                                } else {
                                    maToDoItemLabel.enabled = true
                                    todoItemMouseArea.enabled = true
                                    todoLabel.readOnly = true
                                    todoDetails.readOnly = true
                                    model.details = todoDetails.text.trim()
                                    model.label = todoLabel.text.trim()
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
                    id: todoItemMouseArea
                    anchors.fill: parent
                    propagateComposedEvents: true
                    onDoubleClicked: {
                        model.isSelected = !model.isSelected
                    }
                    onClicked: {
                        mouse.accepted = false
                    }
                    drag.target: draggable
                }

                Item {
                    id: draggable
                    anchors.fill: parent
                    Drag.active: todoItemMouseArea.drag.active
                    Drag.hotSpot.x: 0
                    Drag.hotSpot.y: 0
                    //                    Drag.mimeData: { "text/plain": todoItem.display }
                    Drag.mimeData: {
                        "label": model.label,
                        "details": model.details
                    }
                    Drag.dragType: Drag.Automatic
                    Drag.onDragFinished: (dropAction) => {
                                             if ((dropAction === Qt.MoveAction)) {
                                                 listViewModel.removeRow(model.index)
                                             }
                                         }
                }
            }


            Shadow {
                id: todoItemShadow
                anchors.fill: todoItem
                source: todoItem
            }
        }
    }


    DelegateModel {
        id: visualModel

        model: ToDoModel {
            id: listViewModel
        }
        delegate: todoItemDelegate
    }

    ListView {

        readonly property int _margin: 5

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

        model: visualModel
    }

}
