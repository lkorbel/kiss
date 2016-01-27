#include "recordingpanel.h"
#include "ui_recordingpanel.h"
#include "../plugin/kiss.h"

RecordingPanel::RecordingPanel(Kiss * kiss, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::RecordingPanel),
    mRecording(false)
{
    this->kiss = kiss;
    ui->setupUi(this);
    ui->infoLabel->hide();
    ui->controlFrame->hide();
    mFilename = kiss->generateRecordName();
    ui->fileLabel->setText( mFilename);
}

RecordingPanel::~RecordingPanel()
{
    delete ui;
}

bool RecordingPanel::isRecording() const
{
    return mRecording;
}

void RecordingPanel::setRecording( bool on)
{
    if (mRecording != on) {
        mRecording = on;
        ui->infoLabel->setVisible( on);
        if (on) {
            kiss->startRecording( mFilename);
        } else {
            kiss->stopRecording();
            mFilename = kiss->generateRecordName(); //prevent overwrite
        }
    }
}

void RecordingPanel::on_pauseButton_toggled(bool checked)
{
    checked ? kiss->stopRecording() : kiss->startRecording( mFilename);
}
