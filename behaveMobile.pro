TARGET = behavemobile
TEMPLATE = app

QT += qml quick widgets

OBJECTS_DIR = build
MOC_DIR = build
RCC_DIR = build

CONFIG += c++11

SOURCES += \
    src/main.cpp \
    src/behaveqml.cpp \
    src/behave/behaveRun.cpp \
    src/behave/behaveVector.cpp \
    src/behave/crown.cpp \
    src/behave/crownInputs.cpp \
    src/behave/fuelModelSet.cpp \
    src/behave/newext.cpp \
    src/behave/palmettoGallberry.cpp \
    src/behave/randfuel.cpp \
    src/behave/randthread.cpp \
    src/behave/spot.cpp \
    src/behave/spotInputs.cpp \
    src/behave/surface.cpp \
    src/behave/surfaceFireReactionIntensity.cpp \
    src/behave/surfaceFire.cpp \
    src/behave/surfaceFuelbedIntermediates.cpp \
    src/behave/surfaceInputs.cpp \
    src/behave/surfaceTwoFuelModels.cpp \
    src/behave/westernAspen.cpp \
    src/behave/windAdjustmentFactor.cpp \
    src/behave/windSpeedUtility.cpp

RESOURCES += \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)

HEADERS += \
    src/behaveqml.h \
    src/behave/behaveRun.h \
    src/behave/behaveVector.h \
    src/behave/crown.h \
    src/behave/crownEnums.h \
    src/behave/crownInputs.h \
    src/behave/fuelModelSet.h \
    src/behave/newext.h \
    src/behave/palmettoGallberry.h \
    src/behave/randfuel.h \
    src/behave/randthread.h \
    src/behave/spot.h \
    src/behave/spotEnums.h \
    src/behave/spotInputs.h \
    src/behave/surface.h \
    src/behave/surfaceEnums.h \
    src/behave/surfaceFireReactionIntensity.h \
    src/behave/surfaceFire.h \
    src/behave/surfaceFuelbedIntermediates.h \
    src/behave/surfaceInputs.h \
    src/behave/surfaceTwoFuelModels.h \
    src/behave/westernAspen.h \
    src/behave/windAdjustmentFactor.h \
    src/behave/windSpeedUtility.h

DISTFILES += \
    android/AndroidManifest.xml \

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/src/android
