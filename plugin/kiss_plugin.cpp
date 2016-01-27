#include <QQmlExtensionPlugin>
#include <QtQml>
#include "kiss.h"
//----------------------------------------------------------------------------//
class QKissPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA( IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri)
    {
        Q_ASSERT(uri == QLatin1String("lukhaz.theo.Kiss"));
        qmlRegisterType<Kiss>(uri, 1, 0, "Kiss");
    }
}; 
//----------------------------------------------------------------------------//
#include "kiss_plugin.moc"
