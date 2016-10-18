import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0



Tumbler
{
    function makeAndSetModel(inputObject)
    {
        for (var i = lower; i <= upper; i++)
        {
            inputObject.model.push(i)
        }
        myTumbler.myModel = inputObject.model
    }

    function setProperties(inputObject)
    {
        lower = inputObject.lower
        upper = inputObject.upper
        myDefault = inputObject.myDefault
    }

    function setCurrentIndex(index)
    {
        if(index >= lower && index <= upper)
        myTumbler.currentIndex = parseInt(index)
    }

    id: myTumbler

    property int lower: -1
    property int upper: -1
    property int myDefault: -1
    property var myModel: [0]


    anchors.verticalCenter: parent.verticalCenter

    model: myModel
    visibleItemCount: 2

    font.pointSize: 42
    //height: sizeSettingText.paintedHeight * 0.6
    height: Screen.height / 6
    //width: sizeSettingText.paintedWidth
    width: Screen.width / 4

    contentItem: ListView
    {
        anchors.fill: parent
        model: myTumbler.model
        delegate: myTumbler.delegate
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: height / 2 - (height / visibleItemCount / 2)
        preferredHighlightEnd: height / 2  + (height / visibleItemCount / 2)
        clip: true
    }

    Text
    {
        // Invisible object used to set size of the tumbler
        id: sizeSettingText
        visible: false
        font.pointSize: 80
        text: "A"
    }

    background: Item
    {
        Rectangle
        {
            opacity: myTumbler.enabled ? 0.2 : 0.1
            border.color: "black"
            width: parent.width
            height: 1
            anchors.top: parent.top
        }

        Rectangle
        {
            opacity: myTumbler.enabled ? 0.2 : 0.1
            border.color: "white"
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }

    delegate: Text
    {
        id: myDelegate
        text: modelData
        font: myTumbler.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        //opacity: 0.4 + (Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6)
        //scale: 1.0 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
    }

    Rectangle
    {
        anchors.horizontalCenter: myTumbler.horizontalCenter
//        y: myTumbler.height * 0.4 // Value for 5 visible items
//        y: myTumbler.height * 0.33 // Value for 3 visible items
        y: myTumbler.height * 0.25 // Value for 3 visible items
        width: myTumbler.width * 0.66
        height: 3
        color: "black"
    }

    Rectangle
    {
        anchors.horizontalCenter: myTumbler.horizontalCenter
//        y: myTumbler.height * 0.6 // Value for 5 visible items
//        y: myTumbler.height * 0.67 // Value for 3 visible items
        y: myTumbler.height * 0.75 // Value for 2 visible items
        width: myTumbler.width * 0.66
        height: 3
        color: "black"
    }
}

