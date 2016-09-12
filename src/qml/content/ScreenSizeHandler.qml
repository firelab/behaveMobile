import QtQuick 2.0
import QtQuick.Window 2.2

Item
{
    // dpi is in dots per millimeter
    // the conversion factor to pixels per inch is 25.4
    property int dpi: Screen.pixelDensity * 24.5

    function resizeContentForKeyboard(myContentContainer, myContent)
    {
        //var rectHeight = Qt.inputMethod.keyboardRectangle.height
        var rectHeight = Math.round((Screen.height * 0.5 ) + (dpi * 0.2))
        myContentContainer.contentHeight = myContent.height + 10
        myContentContainer.contentHeight += rectHeight

        //console.log("Content height increased by " + rectHeight)
    }

    function resetContentHeight(myContentContainer, myContent)
    {
        myContentContainer.contentHeight = myContent.height + 10
        //console.log("Content height reset to " + myContentContainer.height)
    }
}
