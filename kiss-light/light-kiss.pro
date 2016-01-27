#-------------------------------------------------
#
# Project created by QtCreator 2014-03-28T11:59:27
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = light-kiss
TEMPLATE = app


SOURCES += main.cpp\
        mainwidget.cpp \
    globalsettings.cpp \
    songselector.cpp \
    ../plugin/kiss.cpp \
    recordingpanel.cpp \
    numberdialog.cpp \
    slimlineedit.cpp

HEADERS  += mainwidget.h \
    globalsettings.h \
    songselector.h \
    ../plugin/kiss.h \
    recordingpanel.h \
    numberdialog.h \
    slimlineedit.h

FORMS    += mainwidget.ui \
    globalsettings.ui \
    songselector.ui \
    recordingpanel.ui

#for cross-platform built we need proper libvlc to link
#LIBS += -L../lib-linux32

LIBS += -lvlc

TRANSLATIONS += kiss_pl.ts

RESOURCES += \
    resource.qrc
