#ifndef BEHAVEQML_H
#define BEHAVEQML_H

#include <QObject>
#include <string>
#include <sstream>
#include "behave/behaveRun.h"
#include "behave/fuelModelSet.h"

template <typename T>
std::string my_to_string(T value)
{
    std::ostringstream os ;
    os << value ;
    return os.str() ;
}

class BehaveQML : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(QString display READ display WRITE setDisplay  NOTIFY displayChanged) // Test
    Q_PROPERTY(QString spreadRate READ spreadRate)
    Q_PROPERTY(QString flameLength READ flameLength)

public:
    BehaveQML(QObject* parent = 0);
    ~BehaveQML();

    enum InputSignal { FuelModelNumberSignal, OneHourMoistureSignal, TenHourMoistureSignal,
                       HundredHourMoistureSignal, LiveHerbaceousMoistureSignal,
                       LiveWoodyMoistureSignal, WindSpeedSignal, SlopeSignal,  CalculateSignal
                     };

    Q_ENUM(InputSignal)

    //QString display() const { return display_; }
    QString spreadRate() const { return spreadRate_; }
    QString flameLength() const { return flameLength_; }

    void setRootObject(QObject* root);

public slots:
    void userInputChanged(const QString&, const BehaveQML::InputSignal&);
    //void setDisplay(const QString& display); // Test
    //void setSpreadRate(const QString& spreadRate);
    //void setFlameLength(const QString& spreadRate);

    bool isFuelMoistureNeeded(const int& fuelModelNumber,  const BehaveQML::InputSignal&);
    void calculateClicked();

signals:
    //void displayChanged(const BehaveQML::InputSignal&); // Test
private slots:
    //void onDisplayChanged(const BehaveQML::InputSignal&); // Test

private:

    QObject *root_;
    FuelModelSet fuelModelSet;
    BehaveRun behaveRun;
    //QString display_; // Test
    QString spreadRate_;
    QString flameLength_;
};

#endif // BEHAVEQML_H
