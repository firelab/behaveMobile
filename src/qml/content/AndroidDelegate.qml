import QtQuick 2.2
import QtQuick.Window 2.2

Item
{
    id: root
    width: parent.width
    height: Screen.height / 10

    property alias text: textitem.text
    signal clicked

    Rectangle
    {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Text
    {
        id: textitem
        color: "white"
        font.pointSize: 25
        //text: modelData
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 30
    }

    Rectangle
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        height: 2
        color: "#424246"
    }

    Image
    {
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/navigation_next_item.png"
    }

    MouseArea
    {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
