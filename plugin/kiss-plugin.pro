TEMPLATE = lib
TARGET = qml_kiss_plugin
QT += qml quick
CONFIG += qt plugin c++14

TARGET = $$qtLibraryTarget($$TARGET)
uri = lukhaz.theo.Kiss

# Input
SOURCES += kiss.cpp kiss_plugin.cpp
HEADERS += kiss.h
OTHER_FILES = qmldir

#Cross-builds on linux x86_64 host
#target: Linux32
#LIBS += -L../lib-linux32

#VLC library
LIBS += -lvlc

