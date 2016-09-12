import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

Rectangle {
    id: myQmlKeyboard
    width: 250
    height: 150
    visible: true

    signal inputFieldChanged(string inputFieldText, string outputFieldTextID)

    property string inputFieldText
    property string outputFieldTextID

    function getInputFieldText() { return inputFieldText }
    function setInputFieldText(newInputFieldText) { inputFieldText = newInputFieldText }

    function getOutputFieldTextID() { return outputFieldTextID }
    function setOutputFieldTextID(newOutputFieldTextID) { outputFieldTextID = newOutputFieldTextID }

    TextField
    {
        id: inputField
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40
        text: ""
        onAccepted: focus = false
        //Keys.onEscapePressed: undo()
        onTextChanged:
        {
            setInputFieldText(text)
        }
    }

    Row
    {
        id: keyRow1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: inputField.bottom
        anchors.topMargin: 20
        Button
        {
            id: button1
            text: qsTr("1")
            onClicked: keyEmitter.emitKey(Qt.Key_1)
        }
        Button
        {
            id: button2
            text: qsTr("2")
            onClicked: keyEmitter.emitKey(Qt.Key_2)
        }
        Button
        {
            id: button3
            text: qsTr("3")
            onClicked: keyEmitter.emitKey(Qt.Key_3)
        }
    }

    Row
    {
        id: keyRow2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: keyRow1.bottom
        Button
        {
            id: buttonBack
            text: qsTr("DEL")
            onClicked: keyEmitter.emitKey(Qt.Key_Backspace)
        }
        Button
        {
            id: buttonEnter
            text: qsTr("OK")
            onClicked:
            {
                keyEmitter.emitKey(Qt.Key_Enter)
                myQmlKeyboard.visible = false
            }
        }
        Button
        {
            id: buttonEsc
            text: qsTr("ESC")
            onClicked:
            {
                keyEmitter.emitKey(Qt.Key_Escape)
                myQmlKeyboard.visible = false
            }
        }
    }
}
