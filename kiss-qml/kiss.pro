TARGET = KiSS
TEMPLATE = app

QT = core gui qml quick multimedia
CONFIG += c++11

OBJECTS_DIR = build
MOC_DIR = build

include(QmlVlc/QmlVlc.pri)
SOURCES += src/main.cpp
 

OTHER_FILES += \
    qml/components/TitledInput.qml \
    qml/components/TitledNumberBox.qml \
    qml/Colors.qml \
    qml/components/Button.qml \
    qml/components/NumberDialog.qml \
    qml/components/StringDialog.qml \
    qml/components/Switch.qml \
    qml/MainPanel.qml \
    qml/main.qml \
    qml/MicroPanel.qml \
    qml/MoviePanel.qml \
    qml/MovieSlot.qml \
    qml/MoviePlayer.qml \
    qml/MusicPanel.qml \
    qml/MusicSlot.qml \
    qml/SettingsPanel.qml


qml_files.path = $$OUT_PWD
qml_files.files = qml
images.path = $$OUT_PWD
images.files = img
settings.path = $$OUT_PWD
settings.files = ../conf/*
INSTALLS += qml_files images settings
