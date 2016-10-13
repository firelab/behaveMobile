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
    contentHeight: myContentColumn.height + 10

    bottomMargin: Qt.inputMethod.visible ? Qt.inputMethod.keyboardRectangle.height : 0

    //boundsBehavior: Flickable.OvershootBounds
    boundsBehavior: Flickable.StopAtBounds

    property int maxInputLabelWidth: liveWoodyMoistureLabel.width
    property int maxUnitLabelWidth: longestUnitLabel.width

    signal userInputChanged(string myInput, int myInputSignal)

    property real progress: 0
    SequentialAnimation on progress
    {
        loops: Animation.Infinite
        running: true
        NumberAnimation
        {
            from: 0
            to: 1
            duration: 3000
        }
        NumberAnimation
        {
            from: 1
            to: 0
            duration: 3000
        }
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

        isNoInput = checkForNoInput(slopeModel)
        if(!isNoInput)
        {
            truthValueForInput[7] = isInputInBounds(slopeModel)
        }

        return (truthValueForInput[0] && truthValueForInput[1] &&
                truthValueForInput[2] && truthValueForInput[3] &&
                truthValueForInput[4] && truthValueForInput[5] &&
                truthValueForInput[6] && truthValueForInput[7])
    }

    function processInput(myModel)
    {
        var isInBounds = isInputInBounds(myModel)
        if(isInBounds)
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
        else
        {
            myOutOfRangeDialog.setProperties(myModel)
            myOutOfRangeDialog.open()
            myModel.text = ""
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
        spacing: 30
        //anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            MySpacer{}
        }

        Row
        {
            //anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: fuelModelLabel
                anchors.verticalCenter: parent.verticalCenter
                text: fuelModelNumberModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: fuelModelUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: ""
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: spreadRateUnitLabel.width
            }

            TextField
            {
                id: fuelModelNumberText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: fuelModelNumberModel.text
                style: touchStyle

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
            //anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: oneHourMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: oneHourMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: oneHourMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: oneHourMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: spreadRateUnitLabel.width
            }

            TextField
            {
                id: oneHourMoistureText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20

                style: touchStyle

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

//            This is a test of the older version of Tumbler with instantaneous setter function
//            Tumbler
//            {
//                id: myTumbler

//                anchors.verticalCenter: parent.verticalCenter

//                TumblerColumn
//                {
//                      model: 300
//                }
//                //visibleItemCount: 3

//                //font.pointSize: 30

//                height: sizeSettingText.paintedHeight * 0.80
//                width: sizeSettingText.paintedWidth

//                Component.onCompleted:
//                {
//                    set the value of tumbler at colunm 0 to 200 in 0 milliseconds
//                    setCurrentIndexAt(0, 200, 0)
//                }
//            }


        }

        Row
        {
            spacing: 20
            MySpacer{}

            Label
            {
                id: tenHourMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: tenHourMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: tenHourMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: tenHourMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: spreadRateUnitLabel.width
            }

            TextField
            {
                id: tenHourMoistureText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: tenHourMoistureModel.text
                style: touchStyle

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
            spacing: 20
            MySpacer{}

            Label
            {
                id: hundredHourMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: hundredHourMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: hundredHourMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: hundredHourMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: hundredHourMoistureText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: hundredHourMoistureModel.text
                style: touchStyle

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
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: liveHerbaceousMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveHerbaceousMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: liveHerbaceousMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveHerbaceousMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: liveHerbaceousMoistureText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: liveHerbaceousMoistureModel.text
                style: touchStyle

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
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: liveWoodyMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveWoodyMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
            }

            Label
            {
                id: liveWoodyMoistureUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveWoodyMoistureModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: liveWoodyMoistureText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: liveWoodyMoistureModel.text
                style: touchStyle

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
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: windSpeedLabel
                anchors.verticalCenter: parent.verticalCenter
                text: windSpeedModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: windSpeedUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: windSpeedModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: windSpeedText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: windSpeedModel.text
                style: touchStyle

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
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: slopeLabel
                anchors.verticalCenter: parent.verticalCenter
                text: slopeModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: slopeUnitsLabel
                anchors.verticalCenter: parent.verticalCenter
                text: slopeModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: slopeText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                text: slopeModel.text
                style: touchStyle

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

                //height: calculateButton.text.height
                //width: calculateButton.text.width

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
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: spreadRateLabel
                anchors.verticalCenter: parent.verticalCenter
                text: spreadRateModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: spreadRateUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: spreadRateModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
            }

            Label
            {
                visible: false
                id: longestUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: longestUnitLableModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
            }

            TextField
            {
                id: spreadRateText
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 25
                text: spreadRateModel.text
                style: touchStyle

                readOnly: true
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: flameLengthLabel
                anchors.verticalCenter: parent.verticalCenter
                text: flameLengthModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }

            Label
            {
                id: flameLengthUnitLabel
                anchors.verticalCenter: parent.verticalCenter
                text: flameLengthModel.myUnits
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxUnitLabelWidth
            }

            TextField
            {
                id: flameLengthText
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: myStyleModel.font.pointSize
                anchors.margins: 25
                text:  flameLengthModel.text
                style: touchStyle

                readOnly: true
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: test1Label
                anchors.verticalCenter: parent.verticalCenter
                text: "test1Label"
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }
            TextField
            {
                id: test1Text
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: myStyleModel.font.pointSize
                anchors.margins: 25
                text: "test1Text"
                style: touchStyle
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: test2Label
                anchors.verticalCenter: parent.verticalCenter
                text: "test2Label"
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }
            TextField
            {
                id: test2Text
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: myStyleModel.font.pointSize
                anchors.margins: 25
                text: "test2Text"
                style: touchStyle
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            MySpacer{}

            Label
            {
                id: test3Label
                anchors.verticalCenter: parent.verticalCenter
                text: "test3Label"
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
            }
            TextField
            {
                id: test3Text
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: myStyleModel.font.pointSize
                anchors.margins: 25
                text: "test3Text"
                style: touchStyle
            }
        }
    }

    TextInputModel
    {
        id: myStyleModel
        font.pointSize: 25
        width: textInputContainer.width - liveHerbaceousMoistureLabel.width - spreadRateUnitLabel.width - 120
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
                implicitHeight: calculateButtonText.paintedHeight + 10
                implicitWidth: calculateButtonText.paintedWidth + 20

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
                        font.pointSize: 20
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
