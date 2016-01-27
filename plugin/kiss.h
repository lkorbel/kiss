//----------------------------------------------------------------------------//
// KIngdom hall Sound System based on VLC
// Łukasz Korbel <korbel85@gmail.com>
// Apr 2013
//----------------------------------------------------------------------------//
#ifndef KISS_H
#define KISS_H
//----------------------------------------------------------------------------//
#include <QObject>
#include <QString>
#include <QTime>
#include <QDir>
//----------------------------------------------------------------------------//
struct libvlc_instance_t;
//----------------------------------------------------------------------------//
class Kiss : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(QString songsPath READ songsPath WRITE setSongsPath NOTIFY songsPathChanged)
    Q_PROPERTY(QString recordsPath READ recordsPath WRITE setRecordsPath NOTIFY recordsPathChanged)
    Q_PROPERTY(QString recordInput READ recordInput WRITE setRecordInput NOTIFY recordInputChanged)

    public:
        Kiss( QObject *parent = 0);
        ~Kiss();
        
        QString songsPath() const;
        void setSongsPath( QString path);
        QString recordsPath() const;
        void setRecordsPath( QString path);
        QString recordInput() const;
        void setRecordInput( QString input);
        int ministryDay() const;
        void setMinistryDay( int day);
        int watchtowerDay() const;
        void setWatchtowerDay( int day);
        QTime ministryTime() const;
        void setMinistryTime( const QTime& time);
        QTime watchtowerTime() const;
        void setWatchtowerTime( const QTime& time);
        
        //Audio
        Q_INVOKABLE void startRecording( QString name);
        Q_INVOKABLE void stopRecording();
        Q_INVOKABLE QString generateRecordName();
        //Music
        Q_INVOKABLE void startMusic( int number);
        Q_INVOKABLE void stopMusic();
        Q_INVOKABLE void playRandom();
        //Settings
        Q_INVOKABLE void loadSettings();
        Q_INVOKABLE void saveSettings();
        
    signals:
        void meetingDayChanged();
        void songFinished();
        void songsPathChanged();
        void recordsPathChanged();
        void recordInputChanged();

    private:
        Q_DISABLE_COPY(Kiss); //we don't want/need copy constructor
        friend void vlcEventHandler(const struct libvlc_event_t *, void *);
        //vlc objects
        libvlc_instance_t *vlcInstance_;
        bool isPlaying_, isRecording_;
        //khss settings
        QDir songsDir_;
        QDir recordsDir_;
        QString recordInput_;
        //TODO deprecated: time management
        int ministryDay_;
        int watchtowerDay_;
        QTime ministryTime_;
        QTime watchtowerTime_;
};
//----------------------------------------------------------------------------//
#endif //KHSS_H

