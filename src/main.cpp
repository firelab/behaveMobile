#include <QDebug>
#include <QtQml/QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include "behaveqml.h"
#include "qtquickcontrolsapplication.h"

int main(int argc, char *argv[])
{
    QtQuickControlsApplication app(argc, argv);
    qmlRegisterType<BehaveQML>("BehaveQMLEnum", 1, 0, "BehaveQML");

    QQmlApplicationEngine engine;

    BehaveQML behave;

    QQmlContext* context = engine.rootContext();

    // Wire up cpp objects to QML application engine
    context->setContextProperty("behave", &behave);

    engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
    {
        return -1;
    }
    return app.exec();
}

