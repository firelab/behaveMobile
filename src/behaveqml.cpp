#include "behaveqml.h"
#include <QVariant>

BehaveQML::BehaveQML(QObject *parent)
    : QObject(parent), root_(0),
      display_(),
      behaveRun(fuelModelSet)
{
    display_ = "";
    connect(this, SIGNAL(displayChanged(const BehaveQML::InputSignal&)), this, SLOT(onDisplayChanged(const BehaveQML::InputSignal&)));
}

BehaveQML::~BehaveQML()
{

}

void BehaveQML::setRootObject(QObject *root)
{
    // disconnect from previous root
    if (root_ != 0) root_->disconnect(this);

    root_ = root;

    if (root_)
    {
        // setup new connections
        connect(root_, SIGNAL(userInputChanged(const QString&, const BehaveQML::InputSignal&)), this, SLOT(userInputChanged(const QString&, const InputSignal&)));
    }
}

// Slot
void BehaveQML::setDisplay(const QString &display)
{
    if (display_ != display)
    {
        display_ = display;
        //emit displayChanged();
    }
}

// Slot
bool BehaveQML::isFuelMoistureNeeded(const int& fuelModelNumber,  const BehaveQML::InputSignal& inputSignal)
{
    bool isThisFuelLoadNeeded = false;
    double load = 0;

    switch(inputSignal)
    {
        case InputSignal::OneHourMoistureSignal:
        {
            load = behaveRun.getFuelLoadOneHour(fuelModelNumber);
            break;
        }
        case InputSignal::TenHourMoistureSignal:
        {
            load = behaveRun.getFuelLoadTenHour(fuelModelNumber);
            break;
        }
        case InputSignal::HundredHourMoistureSignal:
        {
            load = behaveRun.getFuelLoadHundredHour(fuelModelNumber);
            break;
        }
        case InputSignal::LiveHerbaceousMoistureSignal:
        {
            load = behaveRun.getFuelLoadLiveHerbaceous(fuelModelNumber);
            break;
        }
        case InputSignal::LiveWoodyMoistureSignal:
        {
            load = behaveRun.getFuelLoadLiveWoody(fuelModelNumber);
            break;
        }

    }
    if(load > 0)
    {
        isThisFuelLoadNeeded = true;
    }

    return isThisFuelLoadNeeded;
}

// Slot
void BehaveQML::userInputChanged(const QString& text, const InputSignal& inputSignal)
{
    display_ = text;

    switch(inputSignal)
    {
        case InputSignal::FuelModelNumberSignal:
        {
            behaveRun.setFuelModelNumber(text.toInt());
            break;
        }
        case InputSignal::OneHourMoistureSignal:
        {
            behaveRun.setMoistureOneHour(text.toDouble());
            break;
        }
        case InputSignal::TenHourMoistureSignal:
        {
            behaveRun.setMoistureTenHour(text.toDouble());
            break;
        }
        case InputSignal::HundredHourMoistureSignal:
        {
            behaveRun.setMoistureHundredHour(text.toDouble());
            break;
        }
        case InputSignal::LiveHerbaceousMoistureSignal:
        {
            behaveRun.setMoistureLiveHerbaceous(text.toDouble());
            break;
        }
        case InputSignal::LiveWoodyMoistureSignal:
        {
            behaveRun.setMoistureLiveWoody(text.toDouble());
            break;
        }
        case InputSignal::WindSpeedSignal:
        {
            behaveRun.setWindSpeed(text.toDouble());
            break;
        }
        case InputSignal::SlopeSignal:
        {
            behaveRun.setSlope(text.toDouble());
            break;
        }
        case InputSignal::CalculateSignal:
        {
            double directionOfInterest = 0;
            behaveRun.doSurfaceRunInDirectionOfInterest(directionOfInterest);
            double spreadRate = behaveRun.getSurfaceFireSpreadRate();
            display_ = QString::fromStdString(my_to_string(spreadRate));
            emit displayChanged(inputSignal);
            break;
        }
        default:
        {
            // Some kind of error happened...
        }
    }
}

// onDisplayChanged() ////////////////////////////////////////////////////////

void BehaveQML::onDisplayChanged(const InputSignal& inputSignal)
{
    // push the new display value to QML
    if (root_ && (inputSignal == CalculateSignal))
    {
        root_->setProperty("dummy", display_);
    }
}

//void BehaveQML::fuelModelInputChanged(const QString& text)
//{
//    int fuelModelNumber = text.toInt();
//    behaveRun.setFuelModelNumber(fuelModelNumber);
//}

//// Slot
//void BehaveQML::oneHourMoistureInputChanged(const QString& text)
//{
//    double oneHourMoisture = text.toDouble();
//    behaveRun.setMoistureOneHour(oneHourMoisture);
//}

//// Slot
//void BehaveQML::tenHourMoistureInputChanged(const QString& text)
//{
//    double tenHourMoisture = text.toDouble();
//    behaveRun.setMoistureTenHour(tenHourMoisture);
//}

//// Slot
//void BehaveQML::hundredHourMoistureInputChanged(const QString& text)
//{
//    double hundredHourMoisture = text.toDouble();
//    behaveRun.setMoistureHundredHour(hundredHourMoisture);
//}

//// Slot
//void BehaveQML::liveHerbaceousMoistureInputChanged(const QString& text)
//{
//    double liveHerbaceousMoisture = text.toDouble();
//    behaveRun.setMoistureLiveHerbaceous(liveHerbaceousMoisture);
//}

//// Slot
//void BehaveQML::liveWoodyMoistureInputChanged(const QString& text)
//{
//    double liveWoodyMoisture = text.toDouble();
//    behaveRun.setMoistureLiveWoody(liveWoodyMoisture);
//}

//// Slot
//void BehaveQML::windSpeedInputChanged(const QString& text)
//{
//    double windSpeed = text.toDouble();
//    behaveRun.setWindSpeed(windSpeed);
//}

//// Slot
//void BehaveQML::slopeInputChanged(const QString& text)
//{
//    double slope = text.toDouble();
//    behaveRun.setSlope(slope);
//}

// Slot
void BehaveQML::calculateClicked()
{
    double directionOfInterest = 0;
    behaveRun.doSurfaceRunInDirectionOfInterest(directionOfInterest);
    //double spreadRate = behaveRun.getSurfaceFireSpreadRate();

    //ui.spreadRateLineEdit->setText(QString::number(spreadRate, 10, 2));
}

