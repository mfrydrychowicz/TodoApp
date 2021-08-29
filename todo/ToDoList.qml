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
        list: toDoList
    }


    delegate: Item {
        implicitWidth: parent ? parent.width :  Math.max(todoLabel.implicitWidth + 20, todoDetails.implicitWidth + 20)

        implicitHeight: calculateHeight()
        function calculateHeight() {
            var height = todoLabel.implicitHeight + 20
//            console.log(model.label, model.done) // why sometimes undefined undefined?
            if (model.details && model.details.length > 0) {
                height = height + todoDetails.implicitHeight + separator.implicitHeight + 20
            }
            return height
        }

        Pane {
            id: todoItem
            width: parent.width
//            implicitWidth: parent.width
            implicitHeight: calculateHeight()

            background: Rectangle {
                id: paneBackground
                border.width: 1
                radius: 5
                border.color: model.isSelected ? "red" : "white"
            }

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    model.isSelected = !model.isSelected
                }
            }

            Label {
                id: todoLabel
                text: model.label
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            ToolSeparator {
                id: separator
                orientation: Qt.Horizontal
                anchors.top: todoLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                visible: model.details.length > 0
            }

            Text {
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
