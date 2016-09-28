/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
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
        height: titleText.paintedHeight + 20

        Rectangle
        {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 60
            radius: 4
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
        readonly property string myName: "Fuel Model Number"
        readonly property int myInputSignal: BehaveQML.FuelModelNumberSignal
        text: ""
    }

    TextInputModel
    {
        id: oneHourMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 1
        property int upper: 60
        property string myUnits: "%"
        property string myName: "1 Hour Moisture"
        readonly property int myInputSignal: BehaveQML.OneHourMoistureSignal

        text: ""
    }

    TextInputModel
    {
        id: tenHourMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 1
        property int upper: 60
        property string myUnits: "%"
        readonly property string myName: "10 Hour Moisture"
        readonly property int myInputSignal: BehaveQML.TenHourMoistureSignal

        text: ""
    }

    TextInputModel
    {
        id: hundredHourMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 1
        property int upper: 60
        property string myUnits: "%"
        readonly property string myName: "100 Hour Moisture"
        readonly property int myInputSignal: BehaveQML.HundredHourMoistureSignal

        text: ""
    }

    TextInputModel
    {
        id: liveHerbaceousMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 30
        property int upper: 300
        property string myUnits: "%"
        readonly property string myName: "Live Herb. Moisture"
        readonly property int myInputSignal: BehaveQML.LiveHerbaceousMoistureSignal

        text: ""
    }

    TextInputModel
    {
        id: liveWoodyMoistureModel

        property bool isFuelMoistureNeeded: false
        property int lower: 30
        property int upper: 300
        property string myUnits: "%"
        readonly property string myName: "Live Woody Moisture"
        readonly property int myInputSignal: BehaveQML.LiveWoodyMoistureSignal

        text: ""
    }

    TextInputModel
    {
        id: windSpeedModel

        property int lower: 0
        property int upper: 40
        property string myUnits: "mi/h"
        readonly property string myName: "Wind Speed"
        readonly property int myInputSignal: BehaveQML.WindSpeedSignal

        text: ""
    }

    TextInputModel
    {
        id: slopeModel

        property int lower: 0
        property int upper: 604
        property string myUnits: "%"
        readonly property string myName: "Slope"
        readonly property int myInputSignal: BehaveQML.SlopeSignal

        text: ""
    }

    TextInputModel
    {
        id: spreadRateModel
        property string myUnits: "ch/h"
        readonly property string myName: "Spread Rate"

        readOnly: true
        text: ""
    }

    // Load the pages 
    ListModel
    {
        id: pageModel
        ListElement
        {

            title: "Spread Rate Calculation"
            page: "content/TextInputPage.qml"
        }
        ListElement
        {
            title: "Test1"
            page: "content/TextInputPage.qml"
        }
        ListElement
        {
            title: "Test2"
            page: "content/TextInputPage.qml"
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
                delegate: AndroidDelegate
                {
                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        text: " " + title
                        color: "white"
                        font.pointSize: 25
                    }
                    onClicked: stackView.push(Qt.resolvedUrl(page))
                }
            }
        }
    }

}
