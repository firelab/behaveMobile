import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import BehaveQMLEnum 1.0
import QtQuick.Window 2.0

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

    property int maxInputLabelWidth: longestInputLabel.width
    property int maxUnitLabelWidth: longestUnitLabel.width

    Text
    {
        id: longestInputLabel
        visible: false
        font.pointSize: myStyleModel.font.pointSize
        text: "Wind Speed   "

    }

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

    property var comboBoxToFuelModelMapping: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
                                              101, 102, 103, 104, 105, 106, 107, 108, 109]

    function mapToFuelModelNumber(currentIndex)
    {
        return comboBoxToFuelModelMapping[currentIndex]
    }

    function mapToComboBox(fuelModelNumber)
    {
        var comboBoxCurrentIndex
        if(fuelModelNumber >= 1 && fuelModelNumber <= 13)
        {
            comboBoxCurrentIndex = fuelModelNumber - 1
        }
        else if (fuelModelNumber >= 101 && fuelModelNumber <= 109)
        {
            comboBoxCurrentIndex = fuelModelNumber - 88
        }

        return comboBoxCurrentIndex
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
        //var isInBounds = isInputInBounds(myModel)
        //if(isInBounds)
        {
            behave.userInputChanged(myModel.text, myModel.myInputSignal)
//            if (myModel.myInputSignal === BehaveQML.FuelModelNumberSignal)
//            {
//                oneHourMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.OneHourMoistureSignal)
//                tenHourMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.TenHourMoistureSignal)
//                hundredHourMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.HundredHourMoistureSignal)
//                liveHerbaceousMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.LiveHerbaceousMoistureSignal)
//                liveWoodyMoistureModel.isFuelMoistureNeeded = behave.isFuelMoistureNeeded(fuelModelNumberModel.text, BehaveQML.LiveWoodyMoistureSignal)
//            }
//        }
//        else
//        {
//            myOutOfRangeDialog.setProperties(myModel)
//            myOutOfRangeDialog.open()
//            myModel.text = ""
        }
    }

    function updateIsMoistureInputNeeded()
    {
        function updateIsIndividualMoistureInputNeeded(moistureModel)
        {
            if(fuelModelNumberModel.text === "")
            {
                moistureModel.isFuelMoistureNeeded = false
            }
            if(moistureModel.isFuelMoistureNeeded === false)
            {
                // do something to indicate it's not needed here
            }
            else
            {
                // do something to indicate it's needed here
            }
        }

        updateIsIndividualMoistureInputNeeded(oneHourMoistureModel)
        updateIsIndividualMoistureInputNeeded(tenHourMoistureModel)
        updateIsIndividualMoistureInputNeeded(hundredHourMoistureModel)
        updateIsIndividualMoistureInputNeeded(liveHerbaceousMoistureModel)
        updateIsIndividualMoistureInputNeeded(liveWoodyMoistureModel)
    }

    function updateMoistureInputStyle(moistureModel)
    {
        if(fuelModelNumberModel.text === "")
        {
            moistureModel.isFuelMoistureNeeded = false
        }
//        if(moistureText.activeFocus)
//        {
//            if(moistureModel.isFuelMoistureNeeded)
//            {
//                // do something to indicate it's not needed here
//            }
//            else
//            {
//                // do something to indicate it's needed here
//            }
//        }
//        else
//        {
//            if(moistureModel.isFuelMoistureNeeded)
//            {
//                 // do something to indicate it's not needed here
//            }
//            else
//            {
//                // do something to indicate it's needed here
//            }
//        }
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
            anchors.horizontalCenter: parent.horizontalCenter
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

            MyComboBox
            {
                id: fuelModelComboBox
                onActivated:
                {
                    var fuelModelNumber = mapToFuelModelNumber(currentIndex)
                    fuelModelNumberModel.text = fuelModelNumber
                    processInput(fuelModelNumberModel)
                    textInputContainer.forceActiveFocus()
                }

                Component.onCompleted:
                {
                    setModel(fuelModelNumberModel)
                    if(fuelModelNumberModel.text === "")
                    {
                        currentIndex = 0
                    }
                    else
                    {
                        currentIndex = mapToComboBox(fuelModelNumberModel.text)
                    }
                    var fuelModelNumber = mapToFuelModelNumber(currentIndex)
                    fuelModelNumberModel.text = fuelModelNumber
                    processInput(fuelModelNumberModel)
                }
            }
        }

        Row
        {
            id: oneHourMoistureRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

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

            Rectangle
            {
                height: oneHourMoistureTumblerView.height
                width: oneHourMoistureTumblerView.width
                anchors.verticalCenter: parent.verticalCenter
                MyTumbler
                {
                    id: oneHourMoistureTumblerView
                    currentIndex: oneHourMoistureTumblerModel.currentIndex
                    model: oneHourMoistureTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        oneHourMoistureTumblerModel.currentIndex = currentIndex
                    }
                }
            }
        }

        Row
        {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

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

            Rectangle
            {
                height: tenHourMoistureTumblerView.height
                width: tenHourMoistureTumblerView.width
                anchors.verticalCenter: parent.verticalCenter

                MyTumbler
                {
                    anchors.verticalCenter: parent.verticalCenter
                    id: tenHourMoistureTumblerView
                    currentIndex: tenHourMoistureTumblerModel.currentIndex
                    model: tenHourMoistureTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        tenHourMoistureTumblerModel.currentIndex = currentIndex
                    }
                }
            }
        }

        Row
        {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

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

            Rectangle
            {
                height: hundredHourMoistureTumblerView.height
                width: hundredHourMoistureTumblerView.width
                anchors.verticalCenter: parent.verticalCenter
                MyTumbler
                {
                    id: hundredHourMoistureTumblerView
                    currentIndex: hundredHourMoistureTumblerModel.currentIndex
                    model: hundredHourMoistureTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        hundredHourMoistureTumblerModel.currentIndex = currentIndex
                    }
                }
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

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

            Rectangle
            {
                height: liveHerbaceousMoistureTumblerView.height
                width: liveHerbaceousMoistureTumblerView.width
                anchors.verticalCenter: parent.verticalCenter
                MyTumbler
                {
                    anchors.verticalCenter: parent.verticalCenter
                    id: liveHerbaceousMoistureTumblerView
                    currentIndex: liveHerbaceousMoistureTumblerModel.currentIndex
                    model: liveHerbaceousMoistureTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        liveHerbaceousMoistureTumblerModel.currentIndex = currentIndex
                    }
                }
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Label
            {
                id: liveWoodyMoistureLabel
                anchors.verticalCenter: parent.verticalCenter
                text: liveWoodyMoistureModel.myName
                font.pointSize: myStyleModel.font.pointSize
                color: "white"
                width: maxInputLabelWidth
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

            Rectangle
            {
                height: liveWoodyMoistureTumblerView.height
                width: liveWoodyMoistureTumblerView.width
                anchors.verticalCenter: parent.verticalCenter
                MyTumbler
                {
                    anchors.verticalCenter: parent.verticalCenter
                    id: liveWoodyMoistureTumblerView
                    currentIndex: liveWoodyMoistureTumblerModel.currentIndex
                    model: liveWoodyMoistureTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        liveWoodyMoistureTumblerModel.currentIndex = currentIndex
                    }
                }
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

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

            Rectangle
            {
                height: windSpeedTumblerView.height
                width: windSpeedTumblerView.width
                anchors.verticalCenter: parent.verticalCenter
                MyTumbler
                {
                    anchors.verticalCenter: parent.verticalCenter
                    id: windSpeedTumblerView
                    currentIndex: windSpeedTumblerModel.currentIndex
                    model: windSpeedTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        windSpeedTumblerModel.currentIndex = currentIndex
                    }
                }
            }
        }

        Row
        {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

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

            Rectangle
            {
                height: slopeTumblerView.height
                width: slopeTumblerView.width
                anchors.verticalCenter: parent.verticalCenter
                MyTumbler
                {
                    anchors.verticalCenter: parent.verticalCenter
                    id: slopeTumblerView
                    currentIndex: slopeTumblerModel.currentIndex
                    model: slopeTumblerModel.model

                    onCurrentIndexChanged:
                    {
                        slopeTumblerModel.currentIndex = currentIndex
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
                //style: myButtonStyle
                font.pointSize: myStyleModel.font.pointSize

                property bool isAllInputInBounds: false

                //height: calculateButton.text.height
                //width: calculateButton.text.width
                height: text.paintedWidth + 10
                width: text.paintedWidth + 20

                onClicked:
                {
                    forceActiveFocus()

                    isAllInputInBounds = checkIfAllInputInBounds()
                    if(isAllInputInBounds)
                    {
//                        console.debug("calculating!")

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
                //style: touchStyle
                font.pointSize: myStyleModel.font.pointSize
                color: "white"

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
                //style: touchStyle
                color: "white"

                readOnly: true
            }
        }
    }

    TextInputModel
    {
        id: myStyleModel
        font.pointSize: 25
        width: textInputContainer.width - liveHerbaceousMoistureLabel.width - spreadRateUnitLabel.width - 120
    }
}
