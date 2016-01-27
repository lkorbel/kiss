#ifndef SLIMLINEEDIT_H
#define SLIMLINEEDIT_H

#include <QLineEdit>

class SlimLineEdit : public QLineEdit
{
    Q_OBJECT
public:
    explicit SlimLineEdit(QWidget *parent = 0);
    void setVisibleTextLength( int textLength);
    QSize sizeHint() const;

private:
    int mVisibleTextLength;
};

#endif // SLIMLINEEDIT_H
