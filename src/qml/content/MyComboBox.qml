import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0

ComboBox
{
    id: myComboBox

    property var myModel: [0]

    function setModel(inputObject)
    {
        myModel = inputObject.model
    }

    function makeModelFromXtoN(inputObject, X, N)
    {
        if (X <= N)
        {
            for (var i = X; i <= N; i++)
            {
                inputObject.model.push(i)
            }
        }
    }

    model: myModel

    font.pointSize: myStyleModel.font.pointSize

    delegate: ItemDelegate
    {
        width: myComboBox.width * 3
        text: modelData
        font.pointSize: myStyleModel.font.pointSize
        font.weight: myComboBox.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: myComboBox.highlightedIndex == index
    }

    indicator: Canvas
    {
        x: myComboBox.width - width - myComboBox.rightPadding
        y: myComboBox.topPadding + (myComboBox.availableHeight - height) / 2

        property int indicatorHeight: (myComboBox.height / 2)
        property int indicatorWidth: (myComboBox.width / 8)

        contextType: "2d"

        Connections
        {
            target: myComboBox
            onPressedChanged: myComboBox.indicator.requestPaint()
        }

        onPaint:
        {
            context.reset()
            context.moveTo(0, 0)
            context.lineTo(width, 0)
            context.lineTo(width / 2, height)
            context.closePath()
            context.fillStyle = myComboBox.pressed ? "grey" : "white"
            context.fill()
        }
    }

    contentItem: Text {
        leftPadding: 0
        rightPadding: myComboBox.indicator.width + myComboBox.spacing

        text: myComboBox.displayText
        font: myComboBox.font
        color: myComboBox.pressed ? "grey" : "white";
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        color: "#212126"
        border.color: myComboBox.pressed ? "light blue" : "white"
        border.width: myComboBox.visualFocus ? 2 : 1
        radius: 2
    }
}
