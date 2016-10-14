import QtQuick 2.6
import QtQuick.Controls 1.2
import BehaveQMLEnum 1.0
import QtQuick.Window 2.0
import "content"

ApplicationWindow
{
    property int myWidth: Screen.width
    property int myHeight: Screen.height

    visible: true
    width: myWidth
    height: myHeight

    Rectangle
    {
        color: "#212126"
        anchors.fill: parent
    }

    toolBar: BorderImage
    {
        border.bottom: 8
        source: "images/toolbar.png"
        width: parent.width
        height: titleText.paintedHeight + 50

        Rectangle
        {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 10
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image
            {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
            }
            MouseArea
            {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.pop()
            }
        }

        Text
        {
            id: titleText
            font.pointSize: 30
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "BehaveMobile"
        }
    }

    // Load the objects that store user input
    TextInputModel
    {
        id: fuelModelNumberModel

        property int lower: 1
        property int upper: 255
        readonly property string myName: "Fuel Model"
        readonly property int myInputSignal: BehaveQML.FuelModelNumberSignal
        text: ""

        property var model: ["FM1", "FM2", "FM3", "FM4", "FM5", "FM6", "FM7", "FM8", "FM9", "FM10", "FM11", "FM12", "FM13",
                "GR1", "GR2", "GR3", "GR4", "GR5", "GR6", "GR7", "GR8", "GR9"]
    }

    TextInputModel
    {
        id: oneHourMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 1
        property int upper: 60
        property int myDefault: 3
        property string myUnits: "%"
        property string myName: "1 Hour"
        readonly property int myInputSignal: BehaveQML.OneHourMoistureSignal

        text: myDefault
    }

    MyTumbler
    {
        id: oneHourMoistureTumblerModel
        visible: false

        Text
        {
            id: oneHourMoistureTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(oneHourMoistureModel)
            makeAndSetModel(oneHourMoistureTumblerArray)
            setCurrentIndex(oneHourMoistureModel.myDefault - lower)
        }
        onCurrentIndexChanged:
        {

            oneHourMoistureModel.text = currentIndex + lower
        }
    }

    TextInputModel
    {
        id: tenHourMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 1
        property int upper: 60
        property int myDefault: 4
        property string myUnits: "%"
        readonly property string myName: "10 Hour"
        readonly property int myInputSignal: BehaveQML.TenHourMoistureSignal

        text: myDefault
    }

    MySpinBox
    {
        id: tenHourMoistureSpinBoxModel
        visible: false

        value: tenHourMoistureModel.myDefault
        upper: tenHourMoistureModel.upper
        lower: tenHourMoistureModel.lower

        onValueChanged:
        {
            tenHourMoistureModel.text = value
        }
    }

    MyTumbler
    {
        id: tenHourMoistureTumblerModel
        visible: false

        Text
        {
            id: tenHourMoistureTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(tenHourMoistureModel)
            makeAndSetModel(tenHourMoistureTumblerArray)
            setCurrentIndex(tenHourMoistureModel.myDefault - lower)
        }
        onCurrentIndexChanged:
        {
            tenHourMoistureModel.text = currentIndex + lower
        }
    }


    TextInputModel
    {
        id: hundredHourMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 1
        property int upper: 60
        property int myDefault: 5
        property string myUnits: "%"
        readonly property string myName: "100 Hour"
        readonly property int myInputSignal: BehaveQML.HundredHourMoistureSignal

        text: myDefault
    }

    MySpinBox
    {
        id: hundredHourMoistureSpinBoxModel
        visible: false

        value: hundredHourMoistureModel.myDefault
        upper: hundredHourMoistureModel.upper
        lower: hundredHourMoistureModel.lower

        onValueChanged:
        {
            hundredHourMoistureModel.text = value
        }
    }

    MyTumbler
    {
        id: hundredHourMoistureTumblerModel
        visible: false

        Text
        {
            id: hundredHourMoistureTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(hundredHourMoistureModel)
            makeAndSetModel(hundredHourMoistureTumblerArray)
            setCurrentIndex(hundredHourMoistureModel.myDefault - lower)
        }
        onCurrentIndexChanged:
        {
            hundredHourMoistureModel.text = currentIndex + lower
        }
    }

    TextInputModel
    {
        id: liveHerbaceousMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 30
        property int upper: 300
        property int myDefault: 60
        property string myUnits: "%"
        readonly property string myName: "Live Herb"
        readonly property int myInputSignal: BehaveQML.LiveHerbaceousMoistureSignal

        text: ""
    }

    MySpinBox
    {
        id: liveHerbaceousMoistureSpinBoxModel
        visible: false

        value: liveHerbaceousMoistureModel.myDefault
        upper: liveHerbaceousMoistureModel.upper
        lower: liveHerbaceousMoistureModel.lower

        onValueChanged:
        {
            liveHerbaceousMoistureModel.text = value
        }
    }

    MyTumbler
    {
        id: liveHerbaceousMoistureTumblerModel
        visible: false

        Text
        {
            id: liveHerbaceousMoistureTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(liveHerbaceousMoistureModel)
            makeAndSetModel(liveHerbaceousMoistureTumblerArray)
            setCurrentIndex(liveHerbaceousMoistureModel.myDefault - lower)

        }
        onCurrentIndexChanged:
        {
            liveHerbaceousMoistureModel.text = currentIndex + lower
        }
    }

    TextInputModel
    {
        id: liveWoodyMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 30
        property int upper: 300
        property int myDefault: 90
        property string myUnits: "%"
        readonly property string myName: "Live Woody"
        readonly property int myInputSignal: BehaveQML.LiveWoodyMoistureSignal

        text: ""
    }

    MySpinBox
    {
        id: liveWoodyMoistureSpinBoxModel
        visible: false

        value: liveWoodyMoistureModel.myDefault
        upper: liveWoodyMoistureModel.upper
        lower: liveWoodyMoistureModel.lower

        onValueChanged:
        {
            liveWoodyMoistureModel.text = value
        }
    }

    MyTumbler
    {
        id: liveWoodyMoistureTumblerModel
        visible: false

        Text
        {
            id: liveWoodyMoistureTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(liveWoodyMoistureModel)
            makeAndSetModel(liveWoodyMoistureTumblerArray)
            setCurrentIndex(liveWoodyMoistureModel.myDefault - lower)
        }
        onCurrentIndexChanged:
        {
            liveWoodyMoistureModel.text = currentIndex + lower
        }
    }


    TextInputModel
    {
        id: windSpeedModel

        property int lower: 0
        property int upper: 40
        property int myDefault: 5
        property string myUnits: "mi/h"
        readonly property string myName: "Wind Speed"
        readonly property int myInputSignal: BehaveQML.WindSpeedSignal

        text: ""
    }

    MySpinBox
    {
        id: windSpeedSpinBoxModel
        visible: false

        value: windSpeedModel.myDefault
        upper: windSpeedModel.upper
        lower: windSpeedModel.lower

        onValueChanged:
        {
            windSpeedModel.text = value
        }
    }

    MyTumbler
    {
        id: windSpeedTumblerModel
        visible: false

        Text
        {
            id: windSpeedTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(windSpeedModel)
            makeAndSetModel(windSpeedTumblerArray)
            setCurrentIndex(windSpeedModel.myDefault - lower)

        }
        onCurrentIndexChanged:
        {
            windSpeedModel.text = currentIndex + lower
        }
    }

    TextInputModel
    {
        id: slopeModel

        property int lower: 0
        property int upper: 604
        property int myDefault: 0
        property string myUnits: "%"
        readonly property string myName: "Slope"
        readonly property int myInputSignal: BehaveQML.SlopeSignal

        text: ""
    }

    MySpinBox
    {
        id: slopeSpinBoxModel
        visible: false

        value: slopeModel.myDefault
        upper: slopeModel.upper
        lower: slopeModel.lower

        onValueChanged:
        {
            slopeModel.text = value
        }
    }

    MyTumbler
    {
        id: slopeTumblerModel
        visible: false

        Text
        {
            id: slopeTumblerArray
            property var model: []
        }

        Component.onCompleted:
        {
            setProperties(slopeModel)
            makeAndSetModel(slopeTumblerArray)
            setCurrentIndex(slopeModel.myDefault - lower)

        }
        onCurrentIndexChanged:
        {
            slopeModel.text = currentIndex + lower
        }
    }


    TextInputModel
    {
        id: spreadRateModel
        property string myUnits: "ch/h"
        readonly property string myName: "Spread Rate"

        readOnly: true
        text: ""
    }

    TextInputModel
    {
        id: flameLengthModel
        property string myUnits: "ft"
        readonly property string myName: "Flame Length"

        readOnly: true
        text: ""
    }

    TextInputModel
    {
        id: longestUnitLableModel
        property string myUnits: "ch/h"

        readOnly: true
        text: ""
    }

    // Load the pages
    ListModel
    {
        id: pageModel
        ListElement
        {

            title: "Text Boxes"
            page: "content/TextInputPage.qml"
        }
        ListElement
        {
            title: "Combo Box and Spin Boxes"
            page: "content/ComboBoxAndSpinBoxPage.qml"
        }
        ListElement
        {
            title: "All Combo Boxes"
            page: "content/AllComboBoxesPage.qml"
        }
        ListElement
        {
            title: "Combo Box and Tumblers"
            page: "content/ComboBoxAndTumblerPage.qml"
        }
    }

    StackView
    {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true

        Keys.onReleased:
        {
            if (event.key === Qt.Key_Back && stackView.depth > 1)
            {
                stackView.pop();
                event.accepted = true;
            }
        }

        initialItem: Item
        {
            width: parent.width
            height: parent.height

            ListView
            {
                model: pageModel
                anchors.fill: parent
                bottomMargin: 20
                delegate: AndroidDelegate
                {
                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        text: " " + title
                        color: "white"
                        font.pointSize: 30
                        height: text.paintedHeight + 30
                    }
                    onClicked: stackView.push(Qt.resolvedUrl(page))
                }
            }
        }
    }

}
