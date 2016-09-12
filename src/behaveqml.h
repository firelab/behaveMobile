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
    Q_PROPERTY(QString display READ display WRITE setDisplay  NOTIFY displayChanged) // Test

public:
    BehaveQML(QObject* parent = 0);
    ~BehaveQML();

    enum InputSignal { FuelModelNumberSignal, OneHourMoistureSignal, TenHourMoistureSignal,
                       HundredHourMoistureSignal, LiveHerbaceousMoistureSignal,
                       LiveWoodyMoistureSignal, WindSpeedSignal, SlopeSignal,  CalculateSignal
                     };

    Q_ENUM(InputSignal)

    QString display() const { return display_; }

    void setRootObject(QObject* root);

public slots:
    void  userInputChanged(const QString&, const BehaveQML::InputSignal&);
    void setDisplay(const QString& display);
    bool isFuelMoistureNeeded(const int& fuelModelNumber,  const BehaveQML::InputSignal&);
//    void fuelModelInputChanged(const QString& text);
//    void oneHourMoistureInputChanged(const QString& text);
//    void tenHourMoistureInputChanged(const QString& text);
//    void hundredHourMoistureInputChanged(const QString& text);
//    void liveHerbaceousMoistureInputChanged(const QString& text);
//    void liveWoodyMoistureInputChanged(const QString& text);
//    void windSpeedInputChanged(const QString& text);
//    void slopeInputChanged(const QString& text);
    void calculateClicked();

signals:
    // Test
    void displayChanged(const BehaveQML::InputSignal&);

private slots:
    void onDisplayChanged(const BehaveQML::InputSignal&);

private:

    QObject *root_;
    FuelModelSet fuelModelSet;
    BehaveRun behaveRun;
    QString display_; // Test
};

#endif // BEHAVEQML_H
