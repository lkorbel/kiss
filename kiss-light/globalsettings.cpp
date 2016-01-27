#include "globalsettings.h"
#include "ui_globalsettings.h"
#include "../plugin/kiss.h"
#include <QFileDialog>
#include <QLocale>

GlobalSettings::GlobalSettings( Kiss *kiss, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::GlobalSettings)
{
    ui->setupUi(this);
    this->kiss = kiss;
    setWindowFlags( Qt::Dialog | Qt::FramelessWindowHint);
    kiss->loadSettings();
    QLocale locale;
    QStringList weekDays;
    weekDays << locale.dayName( Qt::Monday);
    weekDays << locale.dayName( Qt::Tuesday);
    weekDays << locale.dayName( Qt::Wednesday);
    weekDays << locale.dayName( Qt::Thursday);
    weekDays << locale.dayName( Qt::Friday);
    weekDays << locale.dayName( Qt::Saturday);
    weekDays << locale.dayName( Qt::Sunday);
    ui->ministerialDayBox->addItems( weekDays);
    ui->publicDayBox->addItems( weekDays);
}

GlobalSettings::~GlobalSettings()
{
    delete ui;
}

void GlobalSettings::showSettings()
{
    ui->songPathEdit->setText( kiss->songsPath());
    ui->recordPathEdit->setText( kiss->recordsPath());
    ui->recordInputEdit->setText( kiss->recordInput());
    ui->ministerialDayBox->setCurrentIndex( kiss->ministryDay() - 1);
    ui->ministerialTimeEdit->setTime( kiss->ministryTime());
    ui->publicDayBox->setCurrentIndex( kiss->watchtowerDay() - 1);
    ui->publicTimeEdit->setTime( kiss->watchtowerTime());
    show();
}

void GlobalSettings::on_songPathButton_clicked()
{
    ui->songPathEdit->setText( QFileDialog::getExistingDirectory( this, tr("Katalog ze \"Śpiewajmy Jehowie!\"")));
}

void GlobalSettings::on_recordPathButton_clicked()
{
    ui->recordPathEdit->setText( QFileDialog::getExistingDirectory( this, tr("Miejsce do zapisu nagrań")));
}

void GlobalSettings::on_saveButton_clicked()
{
    hide();
    kiss->setSongsPath( ui->songPathEdit->text());
    kiss->setRecordsPath( ui->recordPathEdit->text());
    kiss->setRecordInput( ui->recordInputEdit->text());
    kiss->setMinistryDay( ui->ministerialDayBox->currentIndex() + 1);
    kiss->setMinistryTime( ui->ministerialTimeEdit->time());
    kiss->setWatchtowerDay( ui->publicDayBox->currentIndex() + 1);
    kiss->setWatchtowerTime( ui->publicTimeEdit->time());
    kiss->saveSettings();
}

void GlobalSettings::on_cancelButton_clicked()
{
    hide();
}
