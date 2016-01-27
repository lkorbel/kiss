TARGET = KiSS
TEMPLATE = app

QT = core gui qml quick

OBJECTS_DIR = build
MOC_DIR = build

SOURCES = src/main.cpp
 

OTHER_FILES += \
    qml/TitledInput.qml \
    qml/Switch.qml \
    qml/StringDialog.qml \
    qml/StreamPanel.qml \
    qml/SettingsPanel.qml \
    qml/NumberDialog.qml \
    qml/MusicSlot.qml \
    qml/MusicPanel.qml \
    qml/MicroPanel.qml \
    qml/MainPanel.qml \
    qml/main.qml \
    qml/Colors.qml \
    qml/ButtonGradient.qml \
    qml/Button.qml
