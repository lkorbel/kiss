//#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
//#include <QQuickView>
//#include <QQmlEngine>
//#include <QSurfaceFormat>
#include <QDateTime>
//-----------------------------------------------------------------------------//
int main( int argc, char** argv )
{
    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv);
    //set random seed for app
    qsrand( QDateTime::currentDateTime().toTime_t());
    QQmlApplicationEngine engine("qml/main.qml");
    return app.exec();
}
/*
    QQuickView view;
    view.setResizeMode( QQuickView::SizeRootObjectToView);
    view.setSource(QUrl::fromLocalFile( "qml/main.qml"));  
    
    QSurfaceFormat format;
    format.setAlphaBufferSize(8);
    view.setFormat(format);
    view.setColor( QColor(0,0,0,0));
    view.showFullScreen();
    
    app.connect( view.engine(), &QQmlEngine::quit,
                 &app, &QCoreApplication::quit);
    return app.exec();
} 
*/
