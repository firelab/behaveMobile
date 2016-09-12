import QtQuick 2.2
import QtQuick.Dialogs 1.1

MessageDialog
{
    property string inputName
    property int lower
    property int upper
    property string inputText

    title: inputName + " Input Out Of Range"

    function setProperties(inputObject)
    {
        inputName = inputObject.myName
        if(inputObject.text === "")
        {
             inputText = "No input"
        }
        else
        {
            inputText = inputObject.text
        }
        lower = inputObject.lower
        upper = inputObject.upper
    }

    text: inputText + " as a value for " + inputName +
          " is out of the accepted range.\n" +
          "Please enter a value between " + lower + " and " + upper

    onAccepted:
    {
        //console.log("OK")
        close()
    }
}
