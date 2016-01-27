#include "mainwidget.h"
#include <QApplication>
#include <QDir>
#include <QFontDatabase>
#include <QFile>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QDir::setCurrent( a.applicationDirPath());

    QFontDatabase fd;
    int id = fd.addApplicationFont("Roboto.ttf");
    a.setFont( QFont( fd.applicationFontFamilies(id).join("")));

    QFile qss("appstyle.qss");
    if (qss.open(QFile::ReadOnly)) {
        a.setStyleSheet(qss.readAll());
        qss.close();
    }

    MainWidget w;
    w.showMaximized();

    return a.exec();
}
