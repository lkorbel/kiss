#ifndef NUMBERDIALOG_H
#define NUMBERDIALOG_H

#include <QDialog>

class NumberDialog : public QDialog
{
    Q_OBJECT
public:
    explicit NumberDialog(QWidget *parent = 0);

signals:
    void selectedNumber(QString);

private slots:
    void buttonClicked();

};

#endif // NUMBERDIALOG_H
