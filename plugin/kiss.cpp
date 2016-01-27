#include "kiss.h"
#include <QSettings>
#include <QDate>
#include <QTime>
#include <QUrl>
#include <vlc/vlc.h>
//TODO add SONG_COUNT to setting
#define SONG_COUNT 142
//----------------------------------------------------------------------------//
#define VLC_DEBUG "-I", "dummy", "-vvv"
#define VLC_USE_CONF "--no-ignore-config", "--config=vlcrc"
//----------------------------------------------------------------------------//
void vlcEventHandler(const struct libvlc_event_t *, void *);
//----------------------------------------------------------------------------//
Kiss:: Kiss( QObject *parent )
    : QObject( parent),
      isPlaying_(false),
      isRecording_(false)
{
    loadSettings();

    //set random seed to current time for different number sequences
    //between application runs
    qsrand( QDateTime::currentDateTime().toTime_t() );

    const char * const argv[] = { VLC_DEBUG, VLC_USE_CONF };
    int argc = sizeof(argv) / sizeof(*argv);
    vlcInstance_ = libvlc_new( argc, argv);
}
//----------------------------------------------------------------------------//
Kiss:: ~Kiss()
{
    libvlc_release( vlcInstance_);
}
//----------------------------------------------------------------------------//
QString Kiss:: songsPath() const
{
    return songsDir_.path();
}
//----------------------------------------------------------------------------//
void Kiss:: setSongsPath( QString path)
{
    if (path != songsDir_.path()) {
        songsDir_.setPath(path);
        emit songsPathChanged();
    }
}
//----------------------------------------------------------------------------//
QString Kiss:: recordsPath() const
{
    return recordsDir_.path();
}
//----------------------------------------------------------------------------//
void Kiss:: setRecordsPath( QString path)
{
    if (path != recordsDir_.path()) {
        recordsDir_.setPath(path);
        emit recordsPathChanged();
    }
}
//----------------------------------------------------------------------------//
QString Kiss:: recordInput() const
{
    return recordInput_;
}
//----------------------------------------------------------------------------//
void Kiss:: setRecordInput( QString input)
{
    if (input != recordInput_)
    {
        recordInput_ = input;
        emit recordInputChanged();
    }
}
//----------------------------------------------------------------------------//
int Kiss:: ministryDay() const
{
    return ministryDay_;
}
//----------------------------------------------------------------------------//
void Kiss:: setMinistryDay( int day)
{
    if (ministryDay_ != day) {
        ministryDay_ = day;
        emit meetingDayChanged();
    }
}
//----------------------------------------------------------------------------//
int Kiss:: watchtowerDay() const
{
    return watchtowerDay_;
}
//----------------------------------------------------------------------------//
void Kiss:: setWatchtowerDay( int day)
{
    if (watchtowerDay_ != day) {
        watchtowerDay_ = day;
        emit meetingDayChanged();
    }
}
//----------------------------------------------------------------------------//
QTime Kiss:: ministryTime() const
{
    return ministryTime_;
}
//----------------------------------------------------------------------------//
void Kiss:: setMinistryTime( const QTime& time)
{
    ministryTime_ = time;
}
//----------------------------------------------------------------------------//
QTime Kiss:: watchtowerTime() const
{
    return watchtowerTime_;
}
//----------------------------------------------------------------------------//
void Kiss:: setWatchtowerTime( const QTime& time)
{
    watchtowerTime_ = time;
}
//----------------------------------------------------------------------------//
void Kiss:: startRecording( QString name)
{
    if (isRecording_) {
        qWarning("KiSS: attempt to restart running record, should stop first");
        return;
    }
    
    QString input = recordInput_;
    QString output = "#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100}"
                     ":file{dst=" + QUrl::fromLocalFile(
                                    recordsDir_.absoluteFilePath(name + ".mp3")).toString()
                     + "}";
    
    if (libvlc_vlm_add_broadcast( vlcInstance_, "record", qPrintable(input),
                                  qPrintable(output), 0, 0, 1, 0) == 0)
    {
        libvlc_vlm_play_media( vlcInstance_, "record");
        isRecording_ = true;
    }
    else qCritical("KiSS: Couldn't start record");
}
//----------------------------------------------------------------------------//
void Kiss:: stopRecording()
{
    if (isRecording_) {
        libvlc_vlm_stop_media( vlcInstance_, "record");
        libvlc_vlm_del_media( vlcInstance_, "record");
        isRecording_ = false;
    }
}
//----------------------------------------------------------------------------//
QString Kiss:: generateRecordName()
{
    QString filename = QDate::currentDate().toString("yyyy-MM-dd-dddd");
    if (recordsDir_.exists(filename + ".mp3")) //prevent overwrite
        filename += QTime::currentTime().toString("-hhmm");
    return filename;
}
//----------------------------------------------------------------------------//
void Kiss:: startMusic( int number)
{
    if (isPlaying_) {
        qWarning("KiSS: attempt to restart running music, should stop first");
        return;
    }

    QString input = QUrl::fromLocalFile(
                    songsDir_.absoluteFilePath(
                    QString("%1.mp3").arg( QString::number(number), 3, '0')))
                    .toString();

    QString output = "#display";
    
    if (libvlc_vlm_add_broadcast( vlcInstance_, "music", qPrintable(input),
                                  qPrintable(output), 0, 0, 1, 0) == 0)
    {
        libvlc_vlm_play_media( vlcInstance_, "music");
        isPlaying_ = true;
        int errno;
        errno = libvlc_event_attach( libvlc_vlm_get_event_manager( vlcInstance_),
                         libvlc_VlmMediaInstanceStatusEnd, &vlcEventHandler, this);
        if (errno)
            qWarning("KiSS: Failed to attach to event manager");
    }
    else qCritical("KiSS: Couldn't add music to play");
}
//----------------------------------------------------------------------------//
void Kiss:: stopMusic()
{
    if (isPlaying_) {
        libvlc_vlm_stop_media( vlcInstance_, "music");
        libvlc_vlm_del_media( vlcInstance_, "music");
        isPlaying_ = false;
        libvlc_event_detach( libvlc_vlm_get_event_manager( vlcInstance_), 
                         libvlc_VlmMediaInstanceStatusEnd, &vlcEventHandler, this);
    }
}
//----------------------------------------------------------------------------//
void Kiss:: playRandom()
{
    startMusic( float(qrand()) / RAND_MAX * (SONG_COUNT-1) + 1 );
}
//----------------------------------------------------------------------------//
void Kiss:: loadSettings()
{
    QSettings sets("kiss.conf", QSettings::IniFormat);
    
    setSongsPath( sets.value("songs_path").toString());
    setRecordsPath( sets.value("records_path").toString());
    setRecordInput( sets.value("record_input").toString());
    setMinistryDay( sets.value("ministry_day").toInt());
    setMinistryTime( sets.value("ministry_time").toTime());
    setWatchtowerDay( sets.value("watchtower_day").toInt());
    setWatchtowerTime( sets.value("watchtower_time").toTime());

    qDebug("song path: %s\nrecord path: %s\nrecord input: %s",
           qPrintable(songsDir_.path()),
           qPrintable(recordsDir_.path()),
           qPrintable(recordInput_));
}
//----------------------------------------------------------------------------//
void Kiss:: saveSettings()
{
    QSettings sets("kiss.conf", QSettings::IniFormat);
    
    sets.setValue( "songs_path", songsDir_.path());
    sets.setValue( "records_path", recordsDir_.path());
    sets.setValue( "record_input", recordInput_);
    sets.setValue( "ministry_day", ministryDay_);
    sets.setValue( "ministry_time", ministryTime_);
    sets.setValue( "watchtower_day", watchtowerDay_);
    sets.setValue( "watchtower_time", watchtowerTime_);
}
//----------------------------------------------------------------------------//
void vlcEventHandler(const libvlc_event_t* event, void* user_data )
{
    qDebug("KiSS: handling vlc event...");

    Kiss *k = (Kiss*) user_data;
    
    switch (event->type) {
        case libvlc_VlmMediaInstanceStatusEnd:
            emit k->songFinished();
        default: ;
    }
}
//----------------------------------------------------------------------------//
