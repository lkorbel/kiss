#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDateTime>
#include "QmlVlc.h"
//-----------------------------------------------------------------------------//
int main( int argc, char** argv )
{
    RegisterQmlVlc();
    QGuiApplication app(argc, argv);
    //set random seed for app
    qsrand( QDateTime::currentDateTime().toTime_t());
    QQmlApplicationEngine engine("qml/main.qml");
    return app.exec();
}

