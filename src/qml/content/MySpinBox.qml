import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.2


SpinBox {
    id: control

    property int lower: -1
    property int upper: -1

    from: lower
    to: upper

    font.pointSize: 25

    implicitWidth: sizeSettingText.paintedWidth
    implicitHeight: sizeSettingText.paintedHeight

    function setProperties(inputObject)
    {
        lower = inputObject.lower
        upper = inputObject.upper
        value = inputObject.value
    }

    Text
    {
        id: sizeSettingText
        // Invisible object used to set size of the spin box

        visible: false
        font.pointSize: 40
        text: "AAAAAA"
    }

    contentItem: Rectangle
    {
        z: 2

        Text
        {
            text: control.textFromValue(control.value, control.locale)
            anchors.fill: parent
            //fontSizeMode: Text.Fit
            font: control.font
//            color: "#21be2b"
//            selectionColor: "#21be2b"
//            selectedTextColor: "#ffffff"

            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }
    }

    up.indicator: Rectangle
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
            font.pointSize: control.font.pointSize
//            color: "#21be2b"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle
    {
        id: downIndicator
        x: control.mirrored ? parent.width - width : 0
        height: parent.height
        width: parent.width * 0.33

//        color: down.pressed ? "#e4e4e4" : "#f6f6f6"
//        border.color: enabled ? "#21be2b" : "#bdbebf"
        border.color: "black"
        border.width: 2

        Text
        {
            text: "-"
            font.pointSize: control.font.pointSize
//            color: "#21be2b"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
