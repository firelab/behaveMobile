import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.2


Rectangle {
    id: control

    property int lower: -1
    property int upper: -1

    property int from: lower
    property int to: upper

    //font.pointSize: 25

    property int value: -1

    implicitWidth: sizeSettingText.paintedWidth
    implicitHeight: sizeSettingText.paintedHeight

    function setProperties(inputObject)
    {
        lower = inputObject.lower
        upper = inputObject.upper
        value = inputObject.value
    }

    function increase()
    {
        value += 1
    }

    function decrease()
    {
        value -= 1
    }

    Text
    {
        id: sizeSettingText
        // Invisible object used to set size of the spin box

        visible: false
        font.pointSize: 42
        text: "AAAAAA"
    }


    Text
    {
        id: controlText
        text: control.value
        //anchors.fill: parent
        fontSizeMode: Text.Fit
        font.pointSize: 35
    //            color: "#21be2b"
    //            selectionColor: "#21be2b"
    //            selectedTextColor: "#ffffff"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        //horizontalAlignment: Qt.AlignHCenter
        //verticalAlignment: Qt.AlignVCenter
    }


    Rectangle
    {
        id: upIndicator
        x: control.mirrored ? 0 : parent.width - width
        height: parent.height
        width: parent.width * 0.33

//        color: up.pressed ? "#e4e4e4" : "#f6f6f6"
//        border.color: enabled ? "red" : "black"
        border.color: "black"
        border.width: 2

        Text
        {
            text: "+"
            font.pointSize: controlText.font.pointSize
//            color: "#21be2b"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea
        {
            id: upMouseArea
            anchors.fill: upIndicator

            onClicked:
            {
                console.debug("Up pressed!")
                if(control.value < upper)
                {
                    control.increase()
                    console.debug("increasing!")
                }
                else
                {
                    console.debug("limit reached!")
                    upTimer.running = false
                }
            }
            onPressAndHold:
            {
                console.debug("Up pressed and held!")
                upTimer.running = true
            }
            onReleased:
            {
                console.debug("Up released!")
                upTimer.running = false
            }
            Timer
            {
                id: upTimer
                interval: 50; running: false; repeat: true
                onTriggered:
                {
                    if(control.value < upper)
                    {
                        control.increase()
                        console.debug("increasing!")
                    }
                    else
                    {
                        console.debug("limit reached!")
                        upTimer.running = false
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: downIndicator
        //x: control.mirrored ? parent.width - width : 0
        x: 0
        height: parent.height
        width: parent.width * 0.33

//        color: down.pressed ? "#e4e4e4" : "#f6f6f6"
 //       border.color: enabled ? "#21be2b" : "#bdbebf"
        border.color: "black"
        border.width: 2

        Text
        {
            text: "-"
            font.pointSize: 25
//            color: "#21be2b"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea
        {
            id: downMouseArea
            anchors.fill: downIndicator

            onPressed:
            {
                console.debug("Down pressed!")
                if(control.value > lower)
                {
                    control.decrease()
                }
                else
                {
                    console.debug("limit reached!")
                    upTimer.running = false
                }
            }
            onPressAndHold:
            {
                console.debug("Down pressed and held!")
                downTimer.running = true
            }
            onReleased:
            {
                console.debug("Down released!")
                downTimer.running = false
            }
            Timer
            {
                id: downTimer
                interval: 50; running: false; repeat: true
                onTriggered:
                {
                    if(control.value > lower)
                    {
                        control.decrease()
                        console.debug("decreasing!")
                    }
                    else
                    {
                        console.debug("limit reached!")
                        downTimer.running = false
                    }
                }
            }
        }
    }


}
