#include "mainwidget.h"
#include "ui_mainwidget.h"
#include "../plugin/kiss.h"
#include "songselector.h"
#include "recordingpanel.h"
#include "globalsettings.h"
#include <QCloseEvent>
#include <QTimer>
#include <QDateTime>

MainWidget::MainWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MainWidget),
    messagesDefaultLife(5), //10s, how long message will be shown if time not specified
    meetingPrepareTime(10 * 60), //10 min, time to start preparation
    meetingSilenceTime(60), // 1min, time to turn off background music
    meetingCountdownTime(10), //10s, must be less than silence time
    meetingDuration(105 * 60), //1h 45m
    earlyEndingThreshold(10 * 60) //10min before time
{
    ui->setupUi(this);
    ui->startButton->hide();
    ui->endButton->hide();
    ui->info->hide();
    ui->warning->hide();
    ui->critical->hide();
    kiss = new Kiss( this );
    connect(kiss, SIGNAL(meetingDayChanged()), this, SLOT(determineMeeting()));

    mSongSelector = new SongSelector( kiss, this);
    ui->songWidget->deleteLater();
    ui->songWidget = mSongSelector;
    ui->gridLayout->addWidget( ui->songWidget, 3, 0);
    connect( mSongSelector, SIGNAL(userWarning(QString)), this, SLOT(showWarning(QString)));
    connect( mSongSelector, SIGNAL(allSongPlayed()), ui->endButton, SLOT(show()));

    mRecordingPanel = new RecordingPanel( kiss, this);
    ui->recordWidget->deleteLater();
    ui->recordWidget = mRecordingPanel;
    ui->gridLayout->addWidget( ui->recordWidget, 3, 4);
    settingsWidget = new GlobalSettings( kiss, this);

    timer = new QTimer( this );
    timer->setInterval( 1000 );
    timer->setSingleShot( false);
    connect( timer, SIGNAL(timeout()), this, SLOT(updateTime()));
    determineMeeting();
    updateTime();
    timer->start();
}

MainWidget::~MainWidget()
{
    delete ui;
}

void MainWidget::closeEvent(QCloseEvent *event)
{
    event->accept();
}

void MainWidget::determineMeeting()
{
    meeting = None;
    int dayOfWeek = QDateTime::currentDateTime().date().dayOfWeek();
    if (dayOfWeek == kiss->ministryDay())
        meeting = Ministry;
    if (dayOfWeek == kiss->watchtowerDay())
        meeting = Watchtower;
}

void MainWidget::updateTime()
{
    QTime now = QTime::currentTime();
    ui->timeLabel->setText( now.toString("hh:mm:ss"));

    updateMessages();
    if (meeting == None)
        return;
    int timeLeft = timeToMeeting( now);

    if (-timeLeft > meetingDuration - earlyEndingThreshold) {
        if (!mSongSelector->isBackgroundMusic())
            mSongSelector->setBackgroundMusic( true);
        return; //likely after meeting
    }

    if (timeLeft <= meetingPrepareTime && !mSongSelector->areSongsPrepared())
        showWarning( tr("Ustaw pieśni na zebranie!"), 2);

    if (timeLeft <= meetingSilenceTime && !mSongSelector->isMeeting()) {
        if (mSongSelector->isBackgroundMusic())
            mSongSelector->setBackgroundMusic( false);
        if(!ui->startButton->isVisible())
            ui->startButton->show();
        if (timeLeft > meetingCountdownTime) //TODO
            showInfo( tr("Poniżej %n minut(y) do rozpoczęcia zebrania.", 0, meetingSilenceTime / 60), meetingSilenceTime - meetingCountdownTime);
    }

    if (timeLeft > 0 && timeLeft <= meetingCountdownTime)
        showInfo( QString(meetingCountdownTime - timeLeft, '.') + QString::number(timeLeft), 1);

    if (timeLeft <= 0 && !mSongSelector->isMeeting()) { //late start
        showCritical( tr("Naciśnij przycisk") + " <b>" + ui->startButton->text() + "</b>", 2);
    }
}

void MainWidget::updateMessages()
{
    if (--infoMessageLife <= 0)
        ui->info->hide();

    if (--warningMessageLife <= 0)
        ui->warning->hide();

    if (--criticalMessageLife <= 0)
        ui->critical->hide();
}

void MainWidget::on_startButton_clicked()
{
    mSongSelector->setMeeting( true);
    mSongSelector->setBackgroundMusic( false);
    mRecordingPanel->setRecording( true );
    ui->startButton->hide();
    ui->settingsButton->hide();
}

void MainWidget::on_endButton_clicked()
{
    mSongSelector->setMeeting( false);
    mSongSelector->setBackgroundMusic( true);
    mRecordingPanel->setRecording( false );
    ui->endButton->hide();
    ui->startButton->show();
    ui->settingsButton->show();

    int elapsedTime = - timeToMeeting( QTime::currentTime());

    if (elapsedTime >= earlyEndingThreshold) //assuming meeting has ended
    {
        int diff = elapsedTime - meetingDuration;
        if (diff <= -60)
            showWarning( QString( tr("Zebranie było krótsze o %n minut(y)!", 0, diff / 60)));
        if (diff >= 60)
            showCritical( QString( tr("Zebranie było dłuższe o %n minut(y)!", 0, diff / 60)));
    }
}

void MainWidget::on_settingsButton_clicked()
{
    settingsWidget->showSettings();
}

int MainWidget::timeToMeeting( QTime now)
{
    QTime launchTime;
    if (meeting == Ministry)
        launchTime = kiss->ministryTime();
    if (meeting == Watchtower)
        launchTime = kiss->watchtowerTime();
    return now.secsTo( launchTime);
}

void MainWidget::showInfo( QString message, int time)
{
    ui->info->setText( message);
    ui->info->show();
    infoMessageLife = time ? time : messagesDefaultLife;
}

void MainWidget::showWarning( QString message, int time)
{
    ui->warning->setText( message);
    ui->warning->show();
    warningMessageLife = time ? time : messagesDefaultLife;
}

void MainWidget::showCritical( QString message, int time)
{
    ui->critical->setText( message);
    ui->critical->show();
    criticalMessageLife = time ? time : messagesDefaultLife;
}
