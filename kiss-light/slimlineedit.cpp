#include "slimlineedit.h"
#include <QFontMetrics>
#include <QStyle>
#include <QStyleOption>
#include <QApplication>

SlimLineEdit::SlimLineEdit(QWidget *parent) :
    QLineEdit(parent),
    mVisibleTextLength(15)
{
}

void SlimLineEdit::setVisibleTextLength( int textLength)
{
    mVisibleTextLength = textLength;
    updateGeometry();
}

QSize SlimLineEdit::sizeHint() const
{
    QFontMetrics fm( font());
    int h = fm.height();
    int m = 0.1 * h; //increase by margin which is set to be 5% of height on each side
    h += m;
    int w = fm.width( QChar('x') ) * mVisibleTextLength + m;
    QStyleOptionFrameV2 opt;
    initStyleOption(&opt);
    return (style()->sizeFromContents(QStyle::CT_LineEdit, &opt, QSize(w, h).
                                          expandedTo(QApplication::globalStrut()), this));
}
