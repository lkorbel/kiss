#include "numberdialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QPushButton>
#include <QSpacerItem>

NumberDialog::NumberDialog(QWidget *parent) :
    QDialog(parent)
{
    setWindowTitle( tr("Wybierz numer pieśni"));

    QVBoxLayout *verticalBox = new QVBoxLayout( this);
    QHBoxLayout *horizontalBox = new QHBoxLayout();

    //number of columns, and total amount of numbers is arbitrary
    int maxInRow = 10;
    for (int i = 1; i <= 135; i++) {
        QPushButton *button = new QPushButton( this);
        button->setText( QString::number( i ));
        connect( button, SIGNAL(clicked()), this, SLOT(buttonClicked()));
        horizontalBox->addWidget( button);
        if (horizontalBox->count() == maxInRow) {
            verticalBox->addLayout( horizontalBox);
            horizontalBox = new QHBoxLayout();
        }
    }
    if (horizontalBox->count()) {
        horizontalBox->addSpacerItem( new QSpacerItem(0,0, QSizePolicy::Expanding));
        verticalBox->addLayout( horizontalBox);
    } else {
        delete horizontalBox;
    }
}

void NumberDialog:: buttonClicked()
{
    QPushButton *button = dynamic_cast<QPushButton*>( sender());
    if (button) {
        emit selectedNumber( button->text());
        close();
    }
}
