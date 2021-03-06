import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Extras 1.4
import QtQuick.Dialogs 1.1
import BehaveQMLEnum 1.0
import QtQuick.Window 2.2

import "../content"

Flickable
{
    id: textInputContainer
    width: parent.width
    height: parent.height
    contentWidth: myContentColumn.width
    contentHeight: myContentColumn.height + 5

    bottomMargin: Qt.inputMethod.visible ? Qt.inputMethod.keyboardRectangle.height : 0
    boundsBehavior: Flickable.StopAtBounds

    property int maxInputLabelWidth: longestInputLabel.paintedWidth
    property int maxUnitLabelWidth: longestUnitLabel.paintedWidth
    property int fittedInputLabelWidth: Math.min((Screen.width * 0.4), maxInputLabelWidth)

    // fittedTextInputWidth below is in case the first argument in max function call below is negative for some reason
    property int fittedTextInputWidth: Math.max((Screen.width - (fittedInputLabelWidth + maxUnitLabelWidth + 50)), maxUnitLabelWidth)

    signal userInputChanged(string myInput, int myInputSignal)

    Text
    {
        id: longestInputLabel
        visible: false
        font.pointSize: myStyleModel.font.pointSize
        text: "Flame Length "
    }

    Text
    {
        id: longestUnitLabel
        visible: false
        font.pointSize: myStyleModel.font.pointSize
        text: "ch/h "
    }

    function isInputInBounds(myModel)
    {
        var isInBounds = false

        if ((parseFloat(myModel.text) >= myModel.lower) && (parseFloat(myModel.text) <= myModel.upper))
        {
            isInBounds = true
        }
        else
        {
            isInBounds = false
        }

        return isInBounds
    }

    function checkIfAllInputInBounds()
    {
        var truthValueForInput = [false, false, false, false, false, false, false, false]
        var isNoInput = false

        function checkBoundsIfFuelMoistureNeeded(myModel)
        {
            var isInBounds = false
            var isMyFuelMoistureNeeded = false

            isMyFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, myModel.myInputSignal)

            if (isMyFuelMoistureNeeded)
            {
                isNoInput = checkForNoInput(myModel)
                isInBounds = isInputInBounds(myModel)
                if(!isInBounds)
                {
                    myOutOfRangeDialog.setProperties(myModel)
                    myOutOfRangeDialog.open()
                    myModel.text = ""
                }
            }
            else
            {
                isInBounds = true
            }

            return isInBounds
        }

        function checkForNoInput(myModel)
        {
            if (myModel.text === "")
            {
                myOutOfRangeDialog.setProperties(myModel)
                myOutOfRangeDialog.open()
                return true
            }
            else
            {
                return false
            }
        }

        // Check bounds of inputs
        isNoInput = checkForNoInput(fuelModelNumberModel)
        if(!isNoInput)
        {
            truthValueForInput[0] = isInputInBounds(fuelModelNumberModel)
        }
        if(!truthValueForInput[0])
        {
            myOutOfRangeDialog.setProperties(fuelModelNumberModel)
            myOutOfRangeDialog.open()
            myModel.text = ""
        }

        // Check bounds of fuel moisture only if needed for particular fuel model
        truthValueForInput[1] = checkBoundsIfFuelMoistureNeeded(oneHourMoistureModel)
        truthValueForInput[2] = checkBoundsIfFuelMoistureNeeded(tenHourMoistureModel)
        truthValueForInput[3] = checkBoundsIfFuelMoistureNeeded(hundredHourMoistureModel)
        truthValueForInput[4] = checkBoundsIfFuelMoistureNeeded(liveHerbaceousMoistureModel)
        truthValueForInput[5] = checkBoundsIfFuelMoistureNeeded(liveWoodyMoistureModel)

        isNoInput = checkForNoInput(windSpeedModel)
        if(!isNoInput)
        {
            truthValueForInput[6] = isInputInBounds(windSpeedModel)
        }
        if(!truthValueForInput[6])
        {
            myOutOfRangeDialog.setProperties(windSpeedModel)
            myOutOfRangeDialog.open()
            myModel.text = ""
        }


        isNoInput = checkForNoInput(slopeModel)
        if(!isNoInput)
        {
            truthValueForInput[7] = isInputInBounds(slopeModel)
        }
        if(!truthValueForInput[7])
        {
            myOutOfRangeDialog.setProperties(slopeModel)
            myOutOfRangeDialog.open()
            myModel.text = ""
        }

        return (truthValueForInput[0] && truthValueForInput[1] &&
                truthValueForInput[2] && truthValueForInput[3] &&
                truthValueForInput[4] && truthValueForInput[5] &&
                truthValueForInput[6] && truthValueForInput[7])
    }

    function processInput(myModel)
    {
        behave.userInputChanged(myModel.text, myModel.myInputSignal)
        if (myModel.myInputSignal === BehaveQML.FuelModelNumberSignal)
        {
            oneHourMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.OneHourMoistureSignal)
            tenHourMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.TenHourMoistureSignal)
            hundredHourMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.HundredHourMoistureSignal)
            liveHerbaceousMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.LiveHerbaceousMoistureSignal)
            liveWoodyMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.LiveWoodyMoistureSignal)
        }
    }

    function updateIsMoistureInputNeeded()
    {
        function updateIsIndividualMoistureInputNeeded(moistureModel, moistureText)
        {
            if(fuelModelNumberModel.text === "")
            {
                moistureModel.isFuelMoistureNeeded = false
            }
            if(moistureModel.isFuelMoistureNeeded === false)
            {
                moistureText.style = touchStyleNotNeeded
            }
            else
            {
                moistureText.style = touchStyle
            }
        }

        updateIsIndividualMoistureInputNeeded(oneHourMoistureModel, oneHourMoistureText)
        updateIsIndividualMoistureInputNeeded(tenHourMoistureModel, tenHourMoistureText)
        updateIsIndividualMoistureInputNeeded(hundredHourMoistureModel, hundredHourMoistureText)
        updateIsIndividualMoistureInputNeeded(liveHerbaceousMoistureModel, liveHerbaceousMoistureText)
        updateIsIndividualMoistureInputNeeded(liveWoodyMoistureModel, liveWoodyMoistureText)
    }

    function updateMoistureInputStyle(moistureModel, moistureText)
    {
        if(fuelModelNumberModel.text === "")
        {
            moistureModel.isFuelMoistureNeeded = false
        }
        if(moistureText.activeFocus)
        {
            if(moistureModel.isFuelMoistureNeeded)
            {
                moistureText.style = touchStyleSelected
            }
            else
            {
                moistureText.style = touchStyleNotNeededSelected
            }
        }
        else
        {
            if(moistureModel.isFuelMoistureNeeded)
            {
                moistureText.style = touchStyle
            }
            else
            {
                moistureText.style = touchStyleNotNeeded
            }
        }
    }

    InputOutOfRange
    {
        id: myOutOfRangeDialog
    }

    Column
    {
        id: myContentColumn
        spacing: 20

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            MySpacer{}
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: fuelModelLabel
                anchors.verticalCenter: parent.verticalCenter

                text: fuelModelNumberModel.myName
                font.pointSize: myStyleModel.font.pointSize
                wrapMode: Text.WordWrap
                color: "white"
                width: fittedInputLabelWidth
            }

            Label
            {
                id: fuelModelUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: ""
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: fuelModelNumberText
                anchors.verticalCenter: parent.verticalCenter

                text: fuelModelNumberModel.text
                style: touchStyle

                width: fittedTextInputWidth
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: IntValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                    fuelModelNumberModel.text = text
                    if(text !== "")
                    {
                        processInput(fuelModelNumberModel)
                    }
                    updateIsMoistureInputNeeded()
                }
                onFocusChanged:
                {
                    fuelModelNumberModel.text = text
                    if(activeFocus)
                    {
                        style = touchStyleSelected
                        if(text !== "")
                        {
                            processInput(fuelModelNumberModel)
                        }
                        updateIsMoistureInputNeeded()
                    }
                    else
                    {
                        style = touchStyle
                    }
                }
                Keys.onReturnPressed:
                {
                    if(text !== "")
                    {
                        //fuelModelNumberModel.text = text.replace(/^0+/, '')
                        fuelModelNumberModel.text = text
                        processInput(fuelModelNumberModel)
                    }

                    updateIsMoistureInputNeeded()
                    textInputContainer.forceActiveFocus()
                    Qt.inputMethod.hide()
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: oneHourMoistureLabel
                anchors.verticalCenter: parent.verticalCenter

                text: oneHourMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                //width: maxInputLabelWidth
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: oneHourMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                text: oneHourMoistureModel.myUnits
                horizontalAlignment: Text.AlignHCenter
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: oneHourMoistureText
                anchors.verticalCenter: parent.verticalCenter


                style: touchStyle

                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                    oneHourMoistureModel.text = text
                }
                onFocusChanged:
                {
                    updateMoistureInputStyle(oneHourMoistureModel, oneHourMoistureText)
                    if(text !== "" && oneHourMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(oneHourMoistureModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    if(text !== "" && oneHourMoistureModel.isFuelMoistureNeeded)
                    {
                        oneHourMoistureModel.text = text
                        processInput(oneHourMoistureModel)
                    }


                    textInputContainer.forceActiveFocus()
                    Qt.inputMethod.hide()
                }
                Component.onCompleted:
                {
                     text = oneHourMoistureModel.text
                     updateMoistureInputStyle(oneHourMoistureModel, oneHourMoistureText)
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: tenHourMoistureLabel

                anchors.verticalCenter: parent.verticalCenter
                text: tenHourMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: tenHourMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: tenHourMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: tenHourMoistureText
                anchors.verticalCenter: parent.verticalCenter

                text: tenHourMoistureModel.text
                style: touchStyle
                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                     tenHourMoistureModel.text = text
                }
                onFocusChanged:
                {
                    updateMoistureInputStyle(tenHourMoistureModel, tenHourMoistureText)
                    if(text !== "" && tenHourMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(tenHourMoistureModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    if(text !== "" && tenHourMoistureModel.isFuelMoistureNeeded)
                    {
                        tenHourMoistureModel.text = text
                        processInput(tenHourMoistureModel)
                    }
                    Qt.inputMethod.hide()
                    textInputContainer.forceActiveFocus()
                }
                Component.onCompleted:
                {
                     updateMoistureInputStyle(tenHourMoistureModel, tenHourMoistureText)
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: hundredHourMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: hundredHourMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: hundredHourMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: hundredHourMoistureModel.myUnits
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: hundredHourMoistureText
                anchors.verticalCenter: parent.verticalCenter  
                text: hundredHourMoistureModel.text
                style: touchStyle
                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                     hundredHourMoistureModel.text = text
                }
                onFocusChanged:
                {
                    updateMoistureInputStyle(hundredHourMoistureModel, hundredHourMoistureText)
                    if(text !== "" && hundredHourMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(hundredHourMoistureModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    if(text !== "" && hundredHourMoistureModel.isFuelMoistureNeeded)
                    {
                        hundredHourMoistureModel.text = text
                        processInput(hundredHourMoistureModel)
                    }
                    Qt.inputMethod.hide()
                    textInputContainer.forceActiveFocus()
                }
                Component.onCompleted:
                {
                     updateMoistureInputStyle(hundredHourMoistureModel, hundredHourMoistureText)
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: liveHerbaceousMoistureLabel          
                anchors.verticalCenter: parent.verticalCenter
                text: liveHerbaceousMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: liveHerbaceousMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveHerbaceousMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: liveHerbaceousMoistureText
                anchors.verticalCenter: parent.verticalCenter            
                text: liveHerbaceousMoistureModel.text
                style: touchStyle
                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                     liveHerbaceousMoistureModel.text = text
                }
                onFocusChanged:
                {
                    updateMoistureInputStyle(liveHerbaceousMoistureModel, liveHerbaceousMoistureText)
                    if(text !== "" && liveHerbaceousMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(liveHerbaceousMoistureModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    Qt.inputMethod.hide()
                    if(text !== "" && liveHerbaceousMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(liveHerbaceousMoistureModel)
                        textInputContainer.forceActiveFocus()
                    }
                }
                Component.onCompleted:
                {
                     updateMoistureInputStyle(liveHerbaceousMoistureModel, liveHerbaceousMoistureText)
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: liveWoodyMoistureLabel
                anchors.verticalCenter: parent.verticalCenter          
                text: liveWoodyMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: liveWoodyMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveWoodyMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: liveWoodyMoistureText
                anchors.verticalCenter: parent.verticalCenter         
                text: liveWoodyMoistureModel.text
                style: touchStyle
                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                     liveWoodyMoistureModel.text = text
                }
                onFocusChanged:
                {
                    updateMoistureInputStyle(liveWoodyMoistureModel, liveWoodyMoistureText)
                    if(text !== "" && liveWoodyMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(liveWoodyMoistureModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    Qt.inputMethod.hide()
                    if(text !== "" && liveWoodyMoistureModel.isFuelMoistureNeeded)
                    {
                        processInput(liveWoodyMoistureModel)
                        textInputContainer.forceActiveFocus()
                    }
                }
                Component.onCompleted:
                {
                     updateMoistureInputStyle(liveWoodyMoistureModel, liveWoodyMoistureText)
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: windSpeedLabel
                anchors.verticalCenter: parent.verticalCenter        
                text: windSpeedModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: windSpeedUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: windSpeedModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: windSpeedText
                anchors.verticalCenter: parent.verticalCenter
                text: windSpeedModel.text
                style: touchStyle
                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                     windSpeedModel.text = text
                }
                onFocusChanged:
                {
                    if(activeFocus)
                    {
                        style = touchStyleSelected
                    }
                    else
                    {
                        style = touchStyle
                    }
                    if(text !== "")
                    {
                        processInput(windSpeedModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    Qt.inputMethod.hide()
                    if(text !== "")
                    {
                        processInput(windSpeedModel)
                        textInputContainer.forceActiveFocus()
                    }
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: slopeLabel
                anchors.verticalCenter: parent.verticalCenter        
                text: slopeModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: slopeUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: slopeModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: slopeText
                anchors.verticalCenter: parent.verticalCenter
                text: slopeModel.text
                style: touchStyle
                width: fittedTextInputWidth

                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator{bottom: 1; top: 999999;}

                onTextChanged:
                {
                     slopeModel.text = text
                }
                onFocusChanged:
                {
                    if(activeFocus)
                    {
                        style = touchStyleSelected
                    }
                    else
                    {
                        style = touchStyle
                    }
                    if(text !== "")
                    {
                        processInput(slopeModel)
                    }
                }
                Keys.onReturnPressed:
                {
                    Qt.inputMethod.hide()
                    if(text !== "")
                    {
                        processInput(slopeModel)
                        textInputContainer.forceActiveFocus()
                    }
                }
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter

            Button
            {
                id: calculateButton
                anchors.verticalCenter: parent.verticalCenter
                text: "Calculate"
                style: myButtonStyle
                property bool isAllInputInBounds: false

                height: calculateButton.text.paintedHeight + 100
                width: calculateButton.text.paintedWidth + 100

                onClicked:
                {
                    forceActiveFocus()
                    isAllInputInBounds = checkIfAllInputInBounds()

                    if(isAllInputInBounds)
                    {
                        // Process inputs
                        processInput(oneHourMoistureModel)
                        processInput(tenHourMoistureModel)
                        processInput(hundredHourMoistureModel)
                        processInput(liveHerbaceousMoistureModel)
                        processInput(liveWoodyMoistureModel)
                        processInput(windSpeedModel)
                        processInput(slopeModel)

                        // Signal to behave to do calculations
                        behave.userInputChanged("Calculate", BehaveQML.CalculateSignal)

                        // Get needed outputs
                        spreadRateText.text = Math.round(behave.spreadRate * 10) / 10
                        flameLengthText.text = Math.round(behave.flameLength * 10) / 10
                    }

                    textInputContainer.forceActiveFocus()
                }
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: spreadRateLabel
                anchors.verticalCenter: parent.verticalCenter           
                text: spreadRateModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: spreadRateUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: spreadRateModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                width: maxUnitLabelWidth
                color: "white"
            }

            TextField
            {
                id: spreadRateText
                anchors.verticalCenter: parent.verticalCenter      
                text: spreadRateModel.text
                font.pointSize: myStyleModel.font.pointSize
                style: touchStyle
                width: fittedTextInputWidth
                readOnly: true
            }
        }

        Row
        {
            spacing: 10
            MySpacer{}

            Label
            {
                id: flameLengthLabel
                anchors.verticalCenter: parent.verticalCenter        
                text: flameLengthModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: fittedInputLabelWidth
                wrapMode: Text.WordWrap
            }

            Label
            {
                id: flameLengthUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: flameLengthModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: flameLengthText
                anchors.verticalCenter: parent.verticalCenter        
                font.pointSize: myStyleModel.font.pointSize
                text:  flameLengthModel.text
                style: touchStyle
                width: fittedTextInputWidth
                readOnly: true
            }
        }
    }

    TextInputModel
    {
        id: myStyleModel
        font.pointSize: 24
    }

    Component
    {
        id: touchStyle

        TextFieldStyle
        {
            font.pointSize: myStyleModel.font.pointSize
            renderType: Text.NativeRendering
            textColor: "white"

            background: Item
            {
                implicitHeight: myStyleModel.height + 5
                implicitWidth: myStyleModel.width

                Rectangle
                {
                    anchors.fill: parent;
                    color: "black";
                    radius: 10;
                    antialiasing: true;
                    border
                    {
                        width: 5;
                        //color: (FocusScope.activeFocus ? "red" : "steelblue");
                        color: "steelblue"
                    }
                }
            }
        }
    }

    Component
    {
        id: touchStyleSelected

        TextFieldStyle
        {
            font.pointSize: myStyleModel.font.pointSize
            renderType: Text.NativeRendering
            textColor: "white"

            background: Item
            {
                implicitHeight: myStyleModel.height + 5
                implicitWidth: myStyleModel.width

                Rectangle
                {
                    anchors.fill: parent;
                    color: "black";
                    radius: 10;
                    antialiasing: true;
                    border
                    {
                        width: 5;
                        color: "red";
                    }
                }
            }
        }
    }

    Component
    {
        id: touchStyleNotNeeded

        TextFieldStyle
        {
            font.pointSize: myStyleModel.font.pointSize
            renderType: Text.NativeRendering
            textColor: "white"

            background: Item
            {
                implicitHeight: myStyleModel.height + 5
                implicitWidth: myStyleModel.width

                Rectangle
                {
                    anchors.fill: parent;
                    color: "#606060";
                    radius: 10;
                    antialiasing: true;
                    border
                    {
                        width: 5;
                        color: "steelblue";
                    }
                }
            }
        }
    }

    Component
    {
        id: touchStyleNotNeededSelected

        TextFieldStyle
        {
            font.pointSize: myStyleModel.font.pointSize
            renderType: Text.NativeRendering
            textColor: "white"

            background: Item
            {
                implicitHeight: myStyleModel.height + 5
                implicitWidth: myStyleModel.width

                Rectangle
                {
                    anchors.fill: parent;
                    color: "#606060";
                    radius: 10;
                    antialiasing: true;
                    border
                    {
                        width: 5;
                        color: "red";
                    }
                }
            }
        }
    }

    Component
    {
        id: myButtonStyle
        ButtonStyle
        {
            panel: Item
            {
                implicitHeight: calculateButtonText.paintedHeight + (calculateButtonText.paintedHeight / 3)
                implicitWidth: calculateButtonText.paintedWidth + (calculateButtonText.paintedWidth / 3)

                BorderImage
                {
                    anchors.fill: parent
                    antialiasing: true
                    border.bottom: 8
                    border.top: 8
                    border.left: 8
                    border.right: 8
                    anchors.margins: control.pressed ? -4 : 0
                    source: control.pressed ? "../images/button_pressed.png" : "../images/button_default.png"
                    Text
                    {
                        id: calculateButtonText
                        text: control.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pointSize: 30
                        renderType: Text.NativeRendering
                    }
                }
            }
        }
    }
    Component.onCompleted:
    {
        forceActiveFocus()
    }
}
