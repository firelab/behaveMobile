import QtQuick 2.0

ListModel
{
    id: pageModel

//        ListElement
//        {
//            title: "Buttons"
//            page: "content/ButtonPage.qml"
//        }
//        ListElement
//        {
//            title: "Sliders"
//            page: "content/SliderPage.qml"
//        }
//        ListElement
//        {
//            title: "ProgressBar"
//            page: "content/ProgressBarPage.qml"
//        }
//        ListElement
//        {
//            title: "Tabs"
//            page: "content/TabBarPage.qml"
//        }

    ListElement
    {
        pageTitle: "Spread Rate Calculation"
        page: "content/TextInputPage.qml"
    }

//        ListElement
//        {
//            title: "List"
//            page: "content/ListPage.qml"
//        }
}
