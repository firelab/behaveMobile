#include "behaveqml.h"
#include <QVariant>

BehaveQML::BehaveQML(QObject *parent)
    : QObject(parent), root_(0),
      behaveRun(fuelModelSet),
      spreadRate_(),
      flameLength_()

{
    spreadRate_ = "";
    flameLength_ = "";
}

BehaveQML::~BehaveQML()
{

}

void BehaveQML::setRootObject(QObject *root)
{
    // disconnect from previous root
    if (root_ != 0) root_->disconnect(this);

    root_ = root;
}

// Slot
//void BehaveQML::setDisplay(const QString &display)
//{
//    if (display_ != display)
//    {
//        display_ = display;
//    }
//}

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
        default:
        {
            // Something went wrong...
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
    //display_ = text;

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
            double localSpreadRate = behaveRun.getSurfaceFireSpreadRate();
            double localFlameLength = behaveRun.getFlameLength();
            spreadRate_ = QString::fromStdString(my_to_string(localSpreadRate));
            flameLength_ = QString::fromStdString(my_to_string(localFlameLength));
            //emit spreadRateChanged(inputSignal);
            break;
        }
        default:
        {
            // Some kind of error happened...
        }
    }
}

// onDisplayChanged() ////////////////////////////////////////////////////////

//void BehaveQML::onDisplayChanged(const InputSignal& inputSignal)
//{
//    // push the new display value to QML
//    if (root_ && (inputSignal == CalculateSignal))
//    {
//        root_->setProperty("dummy", display_);
//    }
//}

// Slot
void BehaveQML::calculateClicked()
{
    double directionOfInterest = 0;
    behaveRun.doSurfaceRunInDirectionOfInterest(directionOfInterest);
}
