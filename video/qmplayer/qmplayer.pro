TEMPLATE = app

QT += qml quick gui
CONFIG += c++11

SOURCES += main.cpp \
    drawbufferitem.cpp \
    buffertexture.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    drawbufferitem.h \
    buffertexture.h
