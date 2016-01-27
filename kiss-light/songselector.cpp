#include "songselector.h"
#include "ui_songselector.h"
#include "numberdialog.h"
#include "../plugin/kiss.h"
#include <QDateTime>

SongSelector::SongSelector( Kiss *kiss, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::SongSelector),
    mSong1(0), mSong2(0), mSong3(0),
    mIsMeeting(false),
    mSongsPrepared(false),
    mBackgroundMusic(true),
    mActivatedSongButton(NULL),
    mActivatedEdit(NULL)
{
    this->kiss = kiss;
    ui->setupUi(this);
    ui->song1Edit->setVisibleTextLength(5);
    ui->song2Edit->setVisibleTextLength(5);
    ui->song3Edit->setVisibleTextLength(5);

    updateMeetingStatus();

    qsrand( QDateTime::currentDateTime().toTime_t() );
    connect( kiss, SIGNAL(songFinished()), this, SLOT(musicIsFinished()));

    mNumberDialog = new NumberDialog( this);
    connect( mNumberDialog, SIGNAL(selectedNumber(QString)), this, SLOT(songSelected(QString)));
}

SongSelector::~SongSelector()
{
    delete ui;
}

bool SongSelector::isMeeting() const
{
    return mIsMeeting;
}

void SongSelector::setMeeting( bool running)
{
    if (mIsMeeting != running) {
        mIsMeeting = running;
        updateMeetingStatus();
    }
}

bool SongSelector::areSongsPrepared() const
{
    return mSongsPrepared;
}

bool SongSelector::isBackgroundMusic() const
{
    return mBackgroundMusic;
}

void SongSelector::setBackgroundMusic( bool enabled)
{
    if (mBackgroundMusic != enabled) {
        mBackgroundMusic = enabled;
        ui->musicButton->setEnabled( enabled);
        ui->musicButton->setChecked( false );

        mActivatedSongButton = NULL;
        kiss->stopMusic();
    }
}

void SongSelector::updateMeetingStatus()
{
    ui->musicButton->setVisible( !mIsMeeting);
    ui->playButton1->setVisible( mIsMeeting);
    ui->playButton2->setVisible( false);
    ui->playButton3->setVisible( false);

    resetMeetingPlayback();
}

void SongSelector::resetMeetingPlayback()
{
    if (mIsMeeting) { //on fly change
        mActivatedSongButton = 0;
        kiss->stopMusic();
        ui->playButton1->setChecked( false );
        ui->playButton1->setEnabled( true );
        ui->playButton2->setChecked( false );
        ui->playButton2->setEnabled( true );
        ui->playButton3->setChecked( false );
        ui->playButton3->setEnabled( true );
    }
}

void SongSelector::on_setSongsButton_clicked()
{
    ui->stackedWidget->setCurrentWidget( ui->setPage);
    if (mIsMeeting)
        emit userWarning(tr("Możliwe zakłócenie odbioru programu!"));
}

void SongSelector::on_song1Button_clicked()
{
    mActivatedEdit = ui->song1Edit;
    mNumberDialog->exec();
}

void SongSelector::on_song2Button_clicked()
{
    mActivatedEdit = ui->song2Edit;
    mNumberDialog->exec();
}

void SongSelector::on_song3Button_clicked()
{
    mActivatedEdit = ui->song3Edit;
    mNumberDialog->exec();
}

void SongSelector::on_cancelButton_clicked()
{
    ui->stackedWidget->setCurrentWidget( ui->controlPage);
}

void SongSelector::on_acceptButton_clicked()
{
    ui->stackedWidget->setCurrentWidget( ui->controlPage);
    mSong1 = ui->song1Edit->text().toInt();
    mSong2 = ui->song2Edit->text().toInt();
    mSong3 = ui->song3Edit->text().toInt();
    ui->song1Label->setText( tr("Pieśń nr") + " " + QString::number( mSong1));
    ui->song2Label->setText( tr("Pieśń nr") + " " + QString::number( mSong2));
    ui->song3Label->setText( tr("Pieśń nr") + " " + QString::number( mSong3));
    mSongsPrepared = true;
    resetMeetingPlayback();
}

void SongSelector::on_musicButton_toggled( bool checked)
{
    if (checked) {
        playRandomSong();
    } else {
        mActivatedSongButton = 0;
        kiss->stopMusic();
    }
}

void SongSelector::on_playButton1_toggled( bool checked)
{
    if (!mSong1) {
        ui->playButton1->setChecked( false);
        return;
    }
    if (checked) {
        kiss->startMusic( mSong1);
        ui->playButton1->setEnabled( false );
        mActivatedSongButton = ui->playButton1;
    }
}

void SongSelector::on_playButton2_toggled( bool checked)
{
    if (checked) {
        kiss->startMusic( mSong2);
        ui->playButton2->setEnabled( false );
        mActivatedSongButton = ui->playButton2;
    }
}

void SongSelector::on_playButton3_toggled( bool checked)
{
    if (checked) {
        kiss->startMusic( mSong3);
        ui->playButton3->setEnabled( false );
        mActivatedSongButton = ui->playButton3;
    }
}

void SongSelector::musicIsFinished()
{
    kiss->stopMusic();

    if (mActivatedSongButton == ui->musicButton) {
        playRandomSong();
        return;
    }

    if (mActivatedSongButton == ui->playButton1) {
        ui->playButton1->setChecked( false );
        ui->playButton1->setEnabled( true );
        ui->playButton1->hide();
        ui->playButton2->show();
        return;
    }

    if (mActivatedSongButton == ui->playButton2) {
        ui->playButton2->setChecked( false );
        ui->playButton2->setEnabled( true );
        ui->playButton2->hide();
        ui->playButton3->show();
        return;
    }

    if (mActivatedSongButton == ui->playButton3) {
        ui->playButton3->setChecked( false );
        ui->playButton3->setEnabled( true );
        ui->playButton3->hide();
        emit allSongPlayed();
        return;
    }
}

void SongSelector::songSelected( QString songNumber)
{
    if (mActivatedEdit) {
        mActivatedEdit->setText( songNumber);
        mActivatedEdit = NULL;
    }
}

void SongSelector::playRandomSong()
{
    qDebug("playing random song");
    kiss->startMusic( float(qrand()) / RAND_MAX * 134 + 1 );
    mActivatedSongButton = ui->musicButton;
}
