import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material.impl 2.12

import ToDoModel 1.0

ListView {
    property int _margin: 5
    implicitWidth:  250
    implicitHeight: 250
    clip: true
    spacing: 5
    leftMargin: _margin
    rightMargin: _margin
    topMargin: _margin
    bottomMargin: _margin

    model: ToDoModel {
        list: toDoList
    }

    delegate: Item {
        implicitWidth: Math.max(todoLabel.implicitWidth + 20, todoDetails.implicitWidth + 20)
        implicitHeight: todoLabel.implicitHeight + 20 + todoDetails.implicitHeight + separator.implicitHeight + 20

        Pane {
            id: todoItem
            implicitWidth: 200
            implicitHeight: calculateHeight()

            function calculateHeight() {
                var height = todoLabel.implicitHeight + 20
                if (model.details.length > 0) {
                    height = height + todoDetails.implicitHeight + separator.implicitHeight + 20
                }
                return height
            }

            background: Rectangle {
                id: paneBackground
                border.width: 1
                radius: 4
                border.color: "lightgray"
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
            anchors.fill: todoItem
            horizontalOffset: 0
            verticalOffset: 0
            radius: 10
            samples: 20
            color: "lightgray"
            source: todoItem
            transparentBorder: true
        }
    }
    //        delegate: Item {
    //            anchors.fill: parent
    //            anchors.margins: 10

    //            Pane {
    //                id: todoItem
    //                implicitWidth: Math.max(todoLabel.implicitWidth + 20, todoDetails.implicitWidth + 20)
    //                implicitHeight: todoLabel.implicitHeight + 20 + todoDetails.implicitHeight + separator.implicitHeight + 20

    //                background: Rectangle {
    //                    id: paneBackground
    //                    border.width: 1
    //                    radius: 4
    //                    border.color: "lightgray"
    //                }

    //                Label {
    //    //                leftPadding: 10
    //    //                rightPadding: 10

    //                    id: todoLabel
    //                    text: model.label

    //                    wrapMode: Text.WrapAnywhere
    //                }

    //                ToolSeparator {
    //                    id: separator
    //                    orientation: Qt.Horizontal
    //                    anchors.top: todoLabel.bottom
    //                    anchors.left: parent.left
    //                    anchors.right: parent.right
    //                }

    //                Text {
    //                    padding: 10
    //                    id: todoDetails
    //                    text: model.details
    //                    anchors.top: separator.bottom
    //                    wrapMode: Text.WrapAnywhere
    //                }
    //            }

    //            DropShadow {
    //                anchors.fill: todoItem
    //                horizontalOffset: 0
    //                verticalOffset: 0
    //                radius: 10
    //                samples: 20
    //                color: "lightgray"
    //                source: todoItem
    //                transparentBorder: true
    //            }
    //        }
}
