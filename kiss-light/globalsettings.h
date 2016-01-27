#ifndef GLOBALSETTINGS_H
#define GLOBALSETTINGS_H

#include <QWidget>

namespace Ui {
class GlobalSettings;
}
class Kiss;

class GlobalSettings : public QWidget
{
    Q_OBJECT

public:
    explicit GlobalSettings( Kiss *kiss, QWidget *parent = 0);
    ~GlobalSettings();
    void showSettings();

private slots:
    void on_songPathButton_clicked();
    void on_recordPathButton_clicked();
    void on_saveButton_clicked();
    void on_cancelButton_clicked();

private:
    Ui::GlobalSettings *ui;
    Kiss *kiss;
};

#endif // GLOBALSETTINGS_H
